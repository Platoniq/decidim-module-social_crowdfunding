# frozen_string_literal: true

require_dependency "decidim/components/namer"

Decidim.register_component(:social_crowdfunding_campaign) do |component|
  component.engine = Decidim::SocialCrowdfunding::Engine
  component.admin_engine = Decidim::SocialCrowdfunding::AdminEngine
  component.icon = "decidim/social_crowdfunding/icon.svg"
  component.permissions_class_name = "Decidim::SocialCrowdfunding::Permissions"

  # These actions permissions can be configured in the admin panel
  # component.actions = %w()

  component.settings(:global) do |settings|
    # Add your global settings
    # Available types: :integer, :boolean
    settings.attribute :campaign_id, type: :string
    settings.attribute :goteo_api_update_hours, type: :integer, default: 24
    settings.attribute :goteo_api_url, type: :string
    settings.attribute :goteo_api_username, type: :string
    settings.attribute :goteo_api_key, type: :string
  end

  component.seeds do |participatory_space|
    # Add some seeds for this component
    admin_user = Decidim::User.find_by(
      organization: participatory_space.organization,
      email: "admin@example.org"
    )

    params = {
      name: Decidim::Components::Namer.new(participatory_space.organization.available_locales, :social_crowdfunding_campaign).i18n_name,
      manifest_name: :social_crowdfunding_campaign,
      published_at: Time.current,
      participatory_space:
    }

    component = Decidim.traceability.perform_action!(
      "publish",
      Decidim::Component,
      admin_user,
      visibility: "all"
    ) do
      Decidim::Component.create!(params)
    end
  end
end
