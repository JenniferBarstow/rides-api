source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0.2"

gem "rails", "~> 7.0.4", ">= 7.0.4.3"
gem "pg", "~> 1.1"
gem "puma", "~> 5.0"
gem "dotenv-rails"
gem "httparty"
gem "kaminari"

gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

gem "bootsnap", require: false

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem "pry"
end

group :test do
  gem "shoulda-matchers", "~> 5.0"
  gem "vcr"
  gem "webmock"
  gem "rspec-rails", "~> 6.0", ">= 6.0.1"
end

