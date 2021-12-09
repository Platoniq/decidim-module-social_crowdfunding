# frozen_string_literal: true

shared_context "with stubs example api" do
  let(:api_url) { "https://api.example.org/" }
  let(:http_method) { :get }
  let(:http_status) { 200 }
  let(:data) { {} }
  let(:params) { {} }

  before do
    allow(Decidim::SocialCrowdfunding::Api::Goteo).to receive(:base_url).and_return(api_url)
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
