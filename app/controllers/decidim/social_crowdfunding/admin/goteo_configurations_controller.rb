# frozen_string_literal: true

module Decidim
  module SocialCrowdfunding
    module Admin
      class GoteoConfigurationsController < Decidim::Admin::Components::BaseController
        include Decidim::Paginable
        include HasGoteoConfiguration

        helper_method :goteo_configurations

        def new
          enforce_permission_to :create, :goteo_configuration

          @form = Decidim::SocialCrowdfunding::Admin::GoteoConfigurationForm.new
        end

        def create
          enforce_permission_to :create, :goteo_configuration

          @form = form(Decidim::SocialCrowdfunding::Admin::GoteoConfigurationForm).from_params(params)

          Decidim::SocialCrowdfunding::Admin::CreateGoteoConfiguration.call(@form, current_user) do
            on(:ok) do
              flash[:notice] = I18n.t("goteo_configurations.create.success", scope: "decidim.social_crowdfunding.admin")
              redirect_to goteo_configurations_path
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("goteo_configurations.create.invalid", scope: "decidim.social_crowdfunding.admin")
              render action: "new"
            end
          end
        end

        def destroy
          enforce_permission_to :destroy, :goteo_configuration

          Decidim::SocialCrowdfunding::GoteoConfiguration.find_by(id: params[:id]).destroy!

          flash[:notice] = I18n.t("goteo_configurations.destroy.success", scope: "decidim.social_crowdfunding.admin")

          redirect_to goteo_configurations_path
        end

        private

        def goteo_configurations
          paginate(collection)
        end

        def collection
          @collection ||= Decidim::SocialCrowdfunding::GoteoConfiguration.where(organization: current_organization)
        end
      end
    end
  end
end
