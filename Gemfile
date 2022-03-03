# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

gem "decidim", "0.25.0"
gem "decidim-phone_authorization_handler", path: "."

gem "bootsnap", "~> 1.4"

gem "foundation_rails_helper", git: "https://github.com/sgruhier/foundation_rails_helper.git"
gem "puma", ">= 5.5.1"

gem "faker", "~> 2.14"
group :development, :test do
  gem "byebug", "~> 11.0", platform: :mri

  gem "decidim-dev", "0.25.0"
end

group :development do
  gem "letter_opener_web", "~> 1.3"
  gem "listen", "~> 3.1"
  gem "rubocop-faker"
  gem "spring", "~> 2.0"
  gem "spring-watcher-listen", "~> 2.0"
  gem "web-console", "4.0.4"
end
