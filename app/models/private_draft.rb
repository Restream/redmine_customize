class PrivateDraft < DraftBase
  belongs_to :user

  validates :user, :presence => true
end
