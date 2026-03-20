# frozen_string_literal: true

module Decidim
  module SocialCrowdfunding
    class GoteoConfiguration < ApplicationRecord
      include Decidim::RecordEncryptor

      self.table_name = "goteo_configurations"

      belongs_to :organization, foreign_key: :decidim_organization_id, class_name: "Decidim::Organization"

      encrypt_attribute :client_id, type: :string
      encrypt_attribute :client_secret, type: :string
      encrypt_attribute :token, type: :string

      def token_valid?
        token.present? && token_expires_at.present? && token_expires_at > Time.current + Goteo::TOKEN_EXPIRY_BUFFER
      end

      def update_token
        response = Goteo::Api.fetch_oauth_token(client_id, client_secret)

        update!(
          token: response["access_token"],
          token_expires_at: response["expires_in"].to_i.seconds.from_now
        )
      end

      def ensure_valid_token!
        update_token unless token_valid?
        token
      end
    end
  end
end
