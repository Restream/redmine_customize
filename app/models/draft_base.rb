class DraftBase < ActiveRecord::Base
  self.table_name = 'drafts'
  belongs_to :project
  attr_accessible :values
  serialize :values, Hash

  validates :project, :presence => true
end
