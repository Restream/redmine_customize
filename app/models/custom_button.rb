class CustomButton < ActiveRecord::Base

  FILTERS = {
      :project       => Project,
      :tracker       => Tracker,
      :status        => IssueStatus,
      :category      => IssueCategory,
      :author        => User,
      :assigned_to   => User,
      :assigned_to_role => Role
  }

  include CustomIcons

  belongs_to :user
  attr_accessible :name, :move_to, :title, :image, :new_values,
                  :custom_field_values, :is_public

  FILTERS.keys.each { |f| attr_accessible "#{f}_ids" }

  serialize :new_values, Hash
  serialize :filters, Hash

  acts_as_list :scope => :user
  acts_as_customizable

  validates :user, :presence => true
  validates :name, :presence => true
  validate do
    unless new_values.values.any? &:present?
      errors[:base] << I18n.t(:text_custom_button_new_values_can_not_be_empty)
    end
  end

  scope :by_position, -> { order("#{table_name}.position") }
  scope :public, -> { where("#{table_name}.is_public = ?", true) }
  scope :private, -> { where("#{table_name}.is_public = ?", false) }

  def available_custom_fields
    CustomField.where('type = ?', 'IssueCustomField').order('position')
  end

  def validate_custom_field_values
    true
  end

  def visible?(issue)
    filters.inject(true) do |r, (filter_key, ids)|
      issue_matched = if filter_key == :assigned_to_role_id
        role_ids = issue.assigned_to && issue.assigned_to.roles_for_project(issue.project).map(&:id)
        role_ids && (role_ids & ids).any?
      else
        ids.include?(issue.send(filter_key))
      end
      r && (ids.nil? || ids.empty? || issue_matched)
    end
  end

  FILTERS.each do |f, klass|
    filter_key = "#{f}_id".to_sym
    filter_getter = "#{f}_ids"
    filter_setter = "#{f}_ids="
    filter_collection = "#{f.to_s.pluralize}"

    define_method filter_getter do
      Array === filters[filter_key] ? filters[filter_key].join(',') : []
    end

    define_method filter_setter do |val|
      ids = val.to_s.split(',').map(&:to_i)
      ids.reject! { |i| i == 0  }
      filters[filter_key] = ids
    end

    define_method filter_collection do
      filters[filter_key] ? klass.where(:id => filters[filter_key]) : []
    end
  end

end
