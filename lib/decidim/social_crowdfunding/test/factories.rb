# frozen_string_literal: true

FactoryBot.define do
  factory :campaign, class: "Decidim::SocialCrowdfunding::Campaign" do
    organization
    name { Decidim::Faker::Localized.word }
    description { Decidim::Faker::Localized.word }
    slug { "nodo-movil" }
    url { "https://goteo.org/project/nodo-movil" }

    data do
      JSON.parse(File.read("spec/fixtures/files/goteo-project.json"))
    end
  end
end
