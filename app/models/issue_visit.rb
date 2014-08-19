class IssueVisit < ActiveRecord::Base
  belongs_to :issue
  belongs_to :user

  class << self
    def find_by_issue(issue, user = User.current)
      where(:user_id => user.id, :issue_id => issue.id).last
    end

    def find_or_initialize_by_issue(issue, user = User.current)
      visits = where(:user_id => user.id, :issue_id => issue.id)
      visits.any? ? visits.last : visits.new
    end

    def save_visit(issue, user = User.current)
      visit = find_or_initialize_by_issue(issue, user)
      visit.last_visit = Time.now
      visit.visit_count ||= 0
      visit.visit_count +=1
      visit.save
    end
  end
end
