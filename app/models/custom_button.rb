class CustomButton < ActiveRecord::Base

  FILTERS = {
      :project      => Project,
      :tracker      => Tracker,
      :status       => IssueStatus,
      :category     => IssueCategory,
      :author       => User,
      :assigned_to  => User
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

  def available_custom_fields
    CustomField.where('type = ?', 'IssueCustomField').order('position')
  end

  def validate_custom_field_values
    true
  end

  def visible?(issue)
    filters.inject(true) do |r, (k, v)|
      r && (v.nil? || v.empty? || v.include?(issue[k]))
    end
  end

  FILTERS.each do |f, klass|
    filter_key = "#{f}_id".to_sym

    define_method "#{f}_ids" do
      Array === filters[filter_key] ? filters[filter_key].join(',') : []
    end

    define_method "#{f}_ids=" do |val|
      filters[filter_key] = val.to_s.split(',').map(&:to_i)
    end

    define_method "#{f.to_s.pluralize}" do
      filters[filter_key] ? klass.where(:id => filters[filter_key]) : []
    end
  end

  #def project_ids
  #  Array === filters[:project_id] ? filters[:project_id].join(',') : []
  #end
  #
  #def project_ids=(val)
  #  filters[:project_id] = val.to_s.split(',')
  #end
  #
  #def projects
  #  filters[:project_id] ? Project.where(:id => filters[:project_id]) : []
  #end

end
