class PublicDraft < DraftBase
  attr_accessible :hex_key

  validates :hex_key, :presence => true
  validates :hex_key, :uniqueness => true
end
