source 'https://rubygems.org'
ruby '~> 2.4.0'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.2.4.3'

# Web server
gem 'puma', '~> 4.3.9'

# Database
gem 'pg', '~> 1.2.3'

# Assets
gem 'chosen-rails'
gem 'coffee-rails', '~> 4.2'
gem 'chartjs-ror'
gem 'bulma-rails', '0.5.1'
gem 'jquery-rails'
gem 'leaflet-rails'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'

# Authentication and authorization
gem 'devise'
gem 'pundit'

# Misc
gem 'jbuilder', '~> 2.5'
gem 'oj'
gem 'oj_mimic_json'
gem 'typhoeus'
gem 'rest-client'
gem 'kaminari', '~> 1.2.1'
gem 'acts_as_list'
gem 'values' # https://github.com/tcrayford/Values
gem 'rails-erd'
gem 'aws-sdk-s3', '~> 1', require: false

# PDF generation / Screenshots
gem 'imgkit'
gem 'wkhtmltoimage-binary'

# Background workers (redis)
gem 'sidekiq', '< 6'
gem "sidekiq-undertaker"
gem "sidekiq-throttled"

# Searching (ES)
gem 'searchkick'

# File text extration (requires Java)
gem 'henkei', git: 'https://github.com/bitzesty/henkei'

# Server monitoring
gem 'scout_apm'
gem 'rollbar'
gem 'health_check'

# Logging
gem "lograge"
gem "logstash-event"

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'pry'
  gem 'rubocop'
  gem 'rubocop-rails'
end

group :development do
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :docsplit do
  gem 'docsplit'
end

group :test do
  gem 'capybara-email'
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'launchy'
  gem 'rails-controller-testing'
  gem 'rspec-activemodel-mocks'
  gem 'rspec-rails'
  gem 'selenium-webdriver' # brew install geckodriver
  gem 'vcr'
  gem 'webmock'
  gem 'rspec_junit_formatter'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
