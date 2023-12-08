# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

require "decidim/phone_authorization_handler/version"

Gem::Specification.new do |s|
  s.version = Decidim::PhoneAuthorizationHandler.version
  s.authors = ["quentinchampenois"]
  s.email = ["quentin.champenois@eemi.com"]
  s.license = "AGPL-3.0"
  s.homepage = "https://github.com/decidim/decidim-module-phone_authorization_handler"
  s.required_ruby_version = ">= 2.7.0"

  s.name = "decidim-phone_authorization_handler"
  s.summary = "A decidim phone_authorization_handler module"
  s.description = "A simple authorization handler which asks to the user a phone number before make action."

  s.files = Dir["{app,config,lib}/**/*", "LICENSE-AGPLv3.txt", "Rakefile", "README.md"]

  s.add_dependency "decidim-core", Decidim::PhoneAuthorizationHandler.decidim_compatibility_version
end
