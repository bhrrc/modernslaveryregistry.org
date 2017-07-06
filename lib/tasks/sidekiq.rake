namespace :sidekiq do
  desc 'clear all jobs from sidekiq'
  task :clear do
    Sidekiq.redis(&:flushdb)
  end
end
