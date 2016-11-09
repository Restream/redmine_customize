require_dependency 'account_controller'

module RedmineCustomize::Patches::AccountControllerPatch
  extend ActiveSupport::Concern

  included do
    alias_method_chain :account_pending, :custom_text
  end

  private

  def account_pending_with_custom_text(*args)
    account_pending_without_custom_text(*args)
    if Setting.self_registration != '1'
      Setting.clear_cache
      custom_notice = Setting['plugin_redmine_customize']['notice_account_pending']
      flash[RedmineCustomize::FLASH_ACCOUNT_PENDING_KEY] = custom_notice if custom_notice.present?
    end
  end
end
