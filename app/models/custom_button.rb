class CustomButton < ActiveRecord::Base

  FILTERS = {
    project:          Project,
    tracker:          Tracker,
    status:           IssueStatus,
    category:         IssueCategory,
    author:           User,
    assigned_to:      User,
    assigned_to_role: Role
  }

  include CustomIcons

  belongs_to :user
  attr_accessible :name, :move_to, :title, :icon, :new_values,
    :custom_field_values, :is_public, :hide_when_nothing_change

  FILTERS.keys.each { |f| attr_accessible "#{f}_ids" }

  serialize :new_values, Hash
  serialize :filters, Hash

  acts_as_list scope: :user
  acts_as_customizable

  validates :user, presence: true
  validates :name, presence: true
  validate do
    unless new_values.values.any? &:present?
      errors[:base] << I18n.t(:text_custom_button_new_values_can_not_be_empty)
    end
  end

  scope :by_position, -> { order("#{table_name}.position") }
  scope :is_public, -> { where("#{table_name}.is_public = ?", true) }
  scope :is_private, -> { where("#{table_name}.is_public = ?", false) }

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
      role_ids.nil? ? false : (role_ids & int_ids).any?
    else
      int_ids.include?(issue.send(filter_key))
    end
  end

  FILTERS.each do |f, klass|
    filter_key        = "#{f}_id".to_sym
    filter_getter     = "#{f}_ids"
    filter_setter     = "#{f}_ids="
    filter_collection = "#{f.to_s.pluralize}"

    define_method filter_getter do
      filters[filter_key]
    end

    define_method filter_setter do |val|
      # Remove empty values
      filters[filter_key] = val.is_a?(Array) ? val.map(&:presence).compact : val
    end

    define_method filter_collection do
      filters[filter_key] ? klass.where(id: filters[filter_key]) : []
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
      has_changes || has_attr_change_for_issue?(issue, key, value)
    end || has_custom_field_changes_for_issue?(issue)
  end

  def has_custom_field_changes_for_issue?(issue)
    issue.custom_field_values.inject(false) do |has_changes, cfvalue|
      new_cfvalue = custom_field_value(cfvalue.custom_field).to_s
      has_changes ||
        (new_cfvalue.present? && cfvalue.value.to_s != new_cfvalue)
    end
  end

  def has_attr_change_for_issue?(issue, attr, value)
    return false if value.blank?
    return false unless issue.safe_attribute?(attr)
    new_value = if attr.to_sym == :assigned_to_id
      issue.custom_user_id(value) || value
    else
      value
    end
    issue.send(attr).to_s != new_value.to_s
  end

end
