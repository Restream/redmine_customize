class CustomButton < ActiveRecord::Base

  include CustomIcons

  belongs_to :user
  attr_accessible :filters, :name, :move_to, :title, :image, :new_values,
                  :custom_field_values, :is_public

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

end
