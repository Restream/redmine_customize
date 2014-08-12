require 'account_controller'

module RedmineCustomize::Patches::AccountControllerPatch
  extend ActiveSupport::Concern

  included do
    alias_method_chain :account_pending, :custom_text
  end

  def account_pending_with_custom_text(*args)
    account_pending_without_custom_text(*args)
    if Setting.self_registration != '1'
      Setting.clear_cache
      custom_notice = Setting['plugin_redmine_customize']['notice_account_pending']
      flash[:notice] = custom_notice if custom_notice.present?
    end
  end
end

unless AccountController.included_modules.include? RedmineCustomize::Patches::AccountControllerPatch
  AccountController.send :include, RedmineCustomize::Patches::AccountControllerPatch
end
