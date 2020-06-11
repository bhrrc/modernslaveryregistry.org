namespace :sidekiq do
  desc 'clear all jobs from sidekiq'
  task :clear do
    require 'sidekiq/api'
    Sidekiq::Queue.new('infinity').clear
    Sidekiq::Queue.new('searchkick').clear
    Sidekiq::RetrySet.new.clear
    Sidekiq::ScheduledSet.new.clear
  end
end
