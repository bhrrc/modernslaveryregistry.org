source 'https://rubygems.org'
ruby '2.4.4'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.2.0'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.0'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'
gem 'jbuilder', '~> 2.5'
gem 'json', '~> 2.0.3'
gem 'acts_as_list'
gem 'bulma-rails', '0.4.3'
gem 'chartjs-ror'
gem 'chosen-rails'
gem 'leaflet-rails'
gem 'devise'
gem 'imgkit'
gem 'kaminari'
gem 'pundit'
gem 'rails-erd'
gem 'rest-client'
gem 'rollbar'
gem 'sidekiq'
gem 'values'
gem 'wkhtmltoimage-binary'
gem 'aws-sdk-s3', require: false

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'pry'
  gem 'rubocop'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'capybara-email'
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'launchy'
  gem 'rails-controller-testing'
  gem 'rspec-rails'
  gem 'selenium-webdriver' # brew install geckodriver
  gem 'vcr'
  gem 'webmock'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
