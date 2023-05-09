# frozen_string_literal: true

module Decidim
  module SocialCrowdfunding
    module Admin
      # A command with all the business logic when selecting a campaign for a component
      class SelectCampaign < Decidim::Command
        # Public: Initializes the command.
        #
        # form - A form object with the params.
        def initialize(form)
          @form = form
        end

        # Executes the command. Broadcasts these events:
        #
        # - :ok when everything is valid.
        # - :invalid if the form wasn't valid and we couldn't proceed.
        #
        # Returns nothing.
        def call
          return broadcast(:invalid) if @form.invalid?

          broadcast(:ok) if select_campaign
        end

        private

        def select_campaign
          settings = current_component.settings
          settings[:campaign_id] = @form.slug

          current_component.update(settings: settings)

          Campaign.fetch(@form.slug, current_component, sync: true)
        end
      end
    end
  end
end
