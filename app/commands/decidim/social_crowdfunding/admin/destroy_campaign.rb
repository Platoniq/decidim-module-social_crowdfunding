# frozen_string_literal: true

module Decidim
  module SocialCrowdfunding
    module Admin
      # A command with all the business logic when destroying a campaign
      class DestroyCampaign < Rectify::Command
        # Public: Initializes the command.
        #
        # form - A form object with the params.
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

        attr_reader :form

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
