# frozen_string_literal: true

shared_context "with stubs example api" do
  let(:api_url) { "https://api.example.org" }
  let(:http_method) { :get }
  let(:http_status) { 200 }
  let(:data) { {} }
  let(:params) { {} }

  before do
    allow(Decidim::SocialCrowdfunding::Goteo).to receive(:api_url).and_return(api_url)

    stub_request(http_method, %r{\A#{api_url}/projects/\d+\z})
      .to_return(status: http_status, body: data.to_json, headers: {})

    stub_request(http_method, %r{\A#{api_url}/accountings/\d+\z})
      .to_return(status: http_status, body: JSON.parse(file_fixture("goteo-accounting.json").read).to_json, headers: {})

    stub_request(http_method, %r{\A#{api_url}/project_budget_items/\d+\z})
      .to_return(status: http_status, body: JSON.parse(file_fixture("goteo-cost.json").read).to_json, headers: {})

    stub_request(http_method, %r{\A#{api_url}/project_rewards/\d+\z})
      .to_return(status: http_status, body: JSON.parse(file_fixture("goteo-reward.json").read).to_json, headers: {})

    stub_request(http_method, %r{\A#{api_url}/user_tokens/\d+\z})
      .to_return(status: http_status, body: JSON.parse(file_fixture("goteo-valid-token.json").read).to_json, headers: {})
  end
end

shared_examples "returns an object" do |property|
  it "returns an object with the result" do
    expect(subject.result).to be_a Hash
    expect(subject.result.keys).to(include?(property)) if property.present?
  end
end

shared_context "with finished campaign component" do
  include_context "with a component" do
    let(:manifest_name) { "social_crowdfunding_campaign" }
    let(:campaign_slug) { "nodo-movil" }

    let!(:data) { JSON.parse(file_fixture("goteo-project-finished.json").read) }

    let(:settings) do
      {
        campaign_id: campaign_slug
      }
    end

    before do
      component.settings = settings
      component.save!

      visit_component
    end

    include_context "with cookies accepted"
  end
end

shared_context "with in progress campaign component" do
  include_context "with a component" do
    let(:manifest_name) { "social_crowdfunding_campaign" }
    let(:campaign_slug) { "la-benefica" }

    let!(:data) { JSON.parse(file_fixture("goteo-project-in-progress.json").read) }

    let(:settings) do
      {
        campaign_id: campaign_slug
      }
    end

    before do
      component.settings = settings
      component.save!

      visit_component
    end

    include_context "with cookies accepted"
  end
end

shared_context "with cookies accepted" do
  before do
    data_consent
  end
end
