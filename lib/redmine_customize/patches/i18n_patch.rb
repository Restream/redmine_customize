require_dependency 'redmine/i18n'

module RedmineCustomize::Patches
  module I18nPatch
    extend ActiveSupport::Concern

    included do
      alias_method_chain :load_translations, :env
    end

    # move redmine plugins locales files to the end of list
    # now plugins can override translations
    def load_translations_with_env(*filenames)
      core_locales_re  = /\A#{Rails.root}\/plugins\//
      sorted_filenames = filenames.flatten.partition { |fn| fn !~ core_locales_re }
      load_translations_without_env sorted_filenames
    end

  end
end
