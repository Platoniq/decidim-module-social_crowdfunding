# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

require "decidim/social_crowdfunding/version"

Gem::Specification.new do |s|
  s.version = Decidim::SocialCrowdfunding::VERSION
  s.authors = ["Ivan Vergés", "Vera Rojman"]
  s.email = ["ivan@platoniq.net", "vera@platoniq.net"]
  s.license = "AGPL-3.0"
  s.homepage = "https://github.com/Platoniq/decidim-module-social_crowdfunding"
  s.required_ruby_version = ">= 2.7"

  s.name = "decidim-social_crowdfunding"
  s.summary = "..."
  s.description = "..."

  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE-AGPLv3.txt", "Rakefile", "README.md"]

  s.add_dependency "decidim-admin", Decidim::SocialCrowdfunding::DECIDIM_VERSION
  s.add_dependency "decidim-core", Decidim::SocialCrowdfunding::DECIDIM_VERSION

  s.add_development_dependency "decidim-dev", Decidim::SocialCrowdfunding::DECIDIM_VERSION
end
