# frozen_string_literal: true

module Decidim
  module SocialCrowdfunding
    module Admin
      # A command with all the business logic when retrieving info from campaign
      class UpdateCampaign < Rectify::Command
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
          begin
            update_campaign!
          rescue StandardError
            return broadcast(:invalid)
          end

          broadcast(:ok)
        end

        attr_reader :campaign

        private

        def update_campaign!
          Decidim.traceability.perform_action!(
            :delete,
            @campaign,
            @user
          ) do
            Campaign.fetch(@campaign.slug, @user.organization, sync: true)
          end
        end
      end
    end
  end
end
