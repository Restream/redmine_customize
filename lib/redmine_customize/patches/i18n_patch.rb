require 'redmine/i18n'

module RedmineCustomize::Patches
  module I18nPatch
    extend ActiveSupport::Concern

    included do
      alias_method_chain :load_translations, :env
    end

    # load redmine core locale files first
    # now plugins can override translations
    def load_translations_with_env(*filenames)
      core_locales_re = /\A#{Rails.root}\/config\/locales\//
      sorted_filenames = filenames.flatten.partition { |fn| fn =~ core_locales_re }
      load_translations_without_env sorted_filenames
    end

  end
end

unless Redmine::I18n::Backend.included_modules.include? RedmineCustomize::Patches::I18nPatch
  Redmine::I18n::Backend.send :include, RedmineCustomize::Patches::I18nPatch
end
