# Redmine - project management software
# Copyright (C) 2006-2013  Jean-Philippe Lang
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

require File.expand_path('../../../test_helper', __FILE__)

class RedmineCustomize::IssuesHelperTest < ActionView::TestCase
  include ApplicationHelper
  include IssuesHelper
  include CustomFieldsHelper
  include ERB::Util
  include RedmineCustomize::Patches::IssuesHelperPatch

  fixtures :projects, :trackers, :issue_statuses, :issues,
    :enumerations, :users, :issue_categories,
    :projects_trackers,
    :roles,
    :member_roles,
    :members,
    :enabled_modules,
    :custom_fields,
    :attachments,
    :versions

  def setup
    super
    set_language_if_valid('en')
    User.current = User.find(1)
    issue        = Issue.find(3)
    journal      = Journal.new(issue: issue)
    @detail      = JournalDetail.new(journal: journal, property: 'attachment', prop_key: '4', old_value: nil, value: 'source.rb')
  end

  def test_show_detail_with_attachment_description
    detail_string = show_detail(@detail, true)
    assert_match 'source.rb', detail_string
  end

  def test_show_detail_with_attachment_size
    detail_string = show_detail(@detail, true)
    assert_match '153 Bytes', detail_string
  end
end
