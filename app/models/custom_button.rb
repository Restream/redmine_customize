class CustomButton < ActiveRecord::Base

  include CustomIcons

  belongs_to :user
  belongs_to :project
  belongs_to :tracker
  belongs_to :status, :class_name => 'IssueStatus'
  belongs_to :category, :class_name => 'IssueCategory'
  belongs_to :author, :class_name => 'User'
  belongs_to :assigned_to, :class_name => 'User'
  attr_accessible :project_id, :tracker_id, :status_id, :category_id, :author_id,
                  :assigned_to_id, :name, :move_to, :title, :image, :new_values,
                  :custom_field_values

  serialize :new_values, Hash

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

  def available_custom_fields
    CustomField.where('type = ?', 'IssueCustomField').order('position')
  end

  def validate_custom_field_values
    true
  end

  def visible?(issue)
    filter_hash.inject(true) do |r, (k, v)|
      r && (v.nil? || issue[k] == v)
    end
  end

  private

  def filter_hash
    {
        :project_id     => project_id,
        :tracker_id     => tracker_id,
        :status_id      => status_id,
        :category_id    => category_id,
        :author_id      => author_id,
        :assigned_to_id => assigned_to_id
    }
  end

end
