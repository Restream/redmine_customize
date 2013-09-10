class CustomButton < ActiveRecord::Base

  FILTERS = {
      :project          => Project,
      :tracker          => Tracker,
      :status           => IssueStatus,
      :category         => IssueCategory,
      :author           => User,
      :assigned_to      => User,
      :assigned_to_role => Role
  }

  include CustomIcons

  belongs_to :user
  attr_accessible :name, :move_to, :title, :image, :new_values,
                  :custom_field_values, :is_public, :hide_when_nothing_change

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
    match_filters?(issue) && show_for_issue?(issue)
  end

  def always_show?
    !hide_when_nothing_change?
  end

  def issue_matched?(issue, filter_key, ids)
    int_ids = ids.map &:to_i
    if filter_key == :assigned_to_role_id
      role_ids = issue.assigned_to && issue.assigned_to.roles_for_project(issue.project).map(&:id)
      role_ids && (role_ids & int_ids).any?
    else
      int_ids.include?(issue.send(filter_key))
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
      ids = val.to_s.split(',')
      ids.reject! { |i| i.to_s == '[]' || i.to_s == '0' }
      filters[filter_key] = ids
    end

    define_method filter_collection do
      filters[filter_key] ? klass.where(:id => filters[filter_key]) : []
    end
  end

  private

  def match_filters?(issue)
    filters.inject(true) do |r, (filter_key, ids)|
      r && (ids.nil? || ids.empty? || issue_matched?(issue, filter_key, ids))
    end
  end

  def show_for_issue?(issue)
    always_show? || has_changes_for_issue?(issue)
  end

  def has_changes_for_issue?(issue)
    new_values.inject(false) do |has_changes, (key, value)|
      has_changes ||
          (value.present? && issue.safe_attribute?(key) &&
              issue.send(key).to_s != value.to_s)
    end || has_custom_field_changes_for_issue?(issue)
  end

  def has_custom_field_changes_for_issue?(issue)
    issue.custom_field_values.inject(false) do |has_changes, cfvalue|
      new_cfvalue = custom_value_for(cfvalue.custom_field)
      has_changes ||
          (new_cfvalue.present? && cfvalue.value.to_s != new_cfvalue.value.to_s)
    end
  end

end
