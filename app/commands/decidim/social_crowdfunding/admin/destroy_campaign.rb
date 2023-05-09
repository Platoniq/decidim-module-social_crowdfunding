# frozen_string_literal: true

module Decidim
  module SocialCrowdfunding
    module Admin
      # A command with all the business logic when destroying a campaign
      class DestroyCampaign < Decidim::Command
        def initialize(campaign, user)
          @campaign = campaign
          @user = user
        end

        # Executes the command. Broadcasts these events:
        #
        # - :ok when everything is valid.
        # - :invalid if the form wasn't valid and we couldn't proceed.
        #
        # Returns nothing.
        def call
          destroy_campaign!
          broadcast(:ok)
        end

        private

        def destroy_campaign!
          Decidim.traceability.perform_action!(
            :delete,
            @campaign,
            @user
          ) do
            @campaign.destroy!
          end
        end
      end
    end
  end
end
