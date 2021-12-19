# frozen_string_literal: true

module Decidim
  module SocialCrowdfunding
    module Admin
      class Permissions < Decidim::DefaultPermissions
        def permissions
          return permission_action if permission_action.scope != :admin

          allowed_campaign_action?

          permission_action
        end

        def allowed_campaign_action?
          return unless permission_action.subject.in? [:campaign, :campaigns]

          case permission_action.action
          when :index, :update, :destroy
            permission_action.allow!
          end
        end

        def campaign
          @campaign ||= context.fetch(:campaign, nil)
        end
      end
    end
  end
end
