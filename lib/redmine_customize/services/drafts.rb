require 'securerandom'

module RedmineCustomize::Services

  class DraftSaveError < StandardError
  end

  class Drafts
    HEX_KEY_LEN = 4
    class << self
      def create_public_draft(project, values)
        draft = project.public_drafts.build :values => values
        draft.hex_key = generate_hex_key
        if draft.save
          draft
        else
          raise DraftSaveError.new("Draft not saved.\n#{draft.errors.full_messages}")
        end
      end

      private

      def generate_hex_key
        SecureRandom.hex(HEX_KEY_LEN)
      end
    end
  end
end
