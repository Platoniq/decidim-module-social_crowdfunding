# frozen_string_literal: true

shared_context "with stubs example api" do
  let(:api_url) { "https://api.example.org/" }
  let(:http_method) { :get }
  let(:http_status) { 200 }
  let(:data) { {} }
  let(:params) { {} }

  before do
    allow(Decidim::SocialCrowdfunding::Goteo).to receive(:api_url).and_return(api_url)
    stub_request(http_method, /api\.example\.org/)
      .to_return(status: http_status, body: data.to_json, headers: {})
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
