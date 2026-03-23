# frozen_string_literal: true

module Decidim
  module SocialCrowdfunding
    module Admin
      class CampaignsController < Decidim::Admin::Components::BaseController
        include Decidim::Paginable
        include HasCampaign
        include HasGoteoConfiguration

        helper Decidim::SocialCrowdfunding::Admin::ApplicationHelper

        helper_method :campaigns

        before_action :check_goteo_config

        def index
          enforce_permission_to :index, :campaigns

          @form = SelectCampaignForm.new
        end

        def fetch
          enforce_permission_to :update, :campaign

          @form = form(SelectCampaignForm).from_params(params)

          if @form.invalid?
            flash[:alert] = I18n.t("campaigns.fetch.error", scope: "decidim.social_crowdfunding.admin")
            return redirect_to root_url
          end

          Campaign.fetch(@form.slug, current_goteo_config.ensure_valid_token!, current_component, sync: true)

          flash[:notice] = I18n.t("campaigns.fetch.success", scope: "decidim.social_crowdfunding.admin")
          redirect_to root_url
        rescue Goteo::Api::Error => e
          flash[:alert] = I18n.t("campaigns.fetch.error", scope: "decidim.social_crowdfunding.admin", error: e.message)
          redirect_to root_url
        end

        def select
          enforce_permission_to :update, :campaign

          @form = form(SelectCampaignForm).from_params(params)

          SelectCampaign.call(@form) do
            on(:ok) do
              flash[:notice] = I18n.t("campaigns.select.success", scope: "decidim.social_crowdfunding.admin")

              redirect_to root_url
            end
            on(:error) do
              flash[:alert] = I18n.t("campaigns.select.error", scope: "decidim.social_crowdfunding.admin")

              render :index
            end
          end
        end

        def update
          enforce_permission_to(:update, :campaign, campaign:)

          UpdateCampaign.call(campaign, current_component, current_user) do
            on(:ok) do
              flash[:notice] = I18n.t("campaigns.update.success", scope: "decidim.social_crowdfunding.admin")

              redirect_to root_url
            end

            on(:error) do
              flash[:alert] = I18n.t("campaigns.update.error", scope: "decidim.social_crowdfunding.admin")

              redirect_to root_url
            end
          end
        end

        def destroy
          enforce_permission_to(:destroy, :campaign, campaign:)

          DestroyCampaign.call(campaign, current_user) do
            on(:ok) do
              flash[:notice] = I18n.t("campaigns.destroy.success", scope: "decidim.social_crowdfunding.admin")

              redirect_to root_url
            end
          end
        end

        private

        def campaign
          @campaign ||= Decidim::SocialCrowdfunding::Campaign.find_by(id: params[:id])
        end

        def campaigns
          paginate(collection)
        end

        def collection
          @collection ||= Decidim::SocialCrowdfunding::Campaign.where(organization: current_organization)
        end
      end
    end
  end
end
