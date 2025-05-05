# frozen_string_literal: true

module Decidim
  module SocialCrowdfunding
    module Admin
      class GoteoConfigurationForm < Decidim::Form
        attribute :email, String
        attribute :password, String

        validates :email, :password, presence: true
      end
    end
  end
end
