class CustomButton < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  belongs_to :tracker
  belongs_to :status
  belongs_to :category
  belongs_to :author
  belongs_to :assigned_to
  attr_accessible :project, :tracker, :status, :category, :author, :assigned_to,
                  :name, :move_to, :title, :image, :new_values

  serialize :new_values, Hash

  acts_as_list :scope => :user

  validates :user, :presence => true
  validates :name, :presence => true
  validate do
    unless new_values.values.any? &:present?
      errors[:base] << I18n.t(:text_custom_button_new_values_can_not_be_empty)
    end
  end

  scope :by_position, -> { order("#{table_name}.position") }
end
