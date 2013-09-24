require 'application_controller'

module RedmineCustomize::Patches::ApplicationControllerPatch
  extend ActiveSupport::Concern

  included do
    before_filter :check_helper_included
  end

  # A way to make plugin helpers available in all views
  def check_helper_included
    unless _helpers.included_modules.include? RedmineCustomizeHelper
      self.class.helper RedmineCustomizeHelper
    end
    true
  end
end

unless ApplicationController.included_modules.include? RedmineCustomize::Patches::ApplicationControllerPatch
  ApplicationController.send :include, RedmineCustomize::Patches::ApplicationControllerPatch
end
