source 'https://rubygems.org'
ruby '~> 2.4.0'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'acts_as_list'
gem 'aws-sdk-s3', require: false
gem 'bulma-rails', '0.4.3'
gem 'chartjs-ror'
gem 'chosen-rails'
gem 'coffee-rails', '~> 4.2'
gem 'devise'
gem 'imgkit'
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails'
gem 'json', '~> 2.0.3'
gem 'kaminari'
gem 'leaflet-rails'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.0'
gem 'pundit'
gem 'rails', '~> 5.2.0'
gem 'rails-erd'
gem 'rest-client'
gem 'rollbar'
gem 'sass-rails', '~> 5.0'
gem 'sidekiq'
gem 'uglifier', '>= 1.3.0'
gem 'values'
gem 'wkhtmltoimage-binary'

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'pry'
  gem 'rubocop'
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
  gem 'rspec-rails'
  gem 'selenium-webdriver' # brew install geckodriver
  gem 'vcr'
  gem 'webmock'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
