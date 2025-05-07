# frozen_string_literal: true

FactoryBot.define do
  factory :campaign, class: "Decidim::SocialCrowdfunding::Campaign" do
    organization
    name { Decidim::Faker::Localized.word }
    description { Decidim::Faker::Localized.word }
    slug { "nodo-movil" }
    url { "https://goteo.org/project/nodo-movil" }

    data do
      JSON.parse(File.read("spec/fixtures/files/goteo-project-finished.json"))
    end
  end

  factory :goteo_configuration, class: "Decidim::SocialCrowdfunding::GoteoConfiguration" do
    organization
    email { "user@example.org" }
    password { "123456" }
    token { "abc123def" }
    goteo_uid { 1 }
  end
end
