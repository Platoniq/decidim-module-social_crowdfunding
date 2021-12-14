# frozen_string_literal: true

module Decidim
  module SocialCrowdfunding
    module Admin
      # Custom helpers, scoped to the social_crowdfunding engine.
      #
      module ApplicationHelper
        def manage_campaign_path
          Decidim::EngineRouter.admin_proxy(current_component.participatory_space).edit_component_path(current_component.id)
        end

        def create_campaign_path
          Goteo.create_campaign_url
        end
      end
    end
  end
end
