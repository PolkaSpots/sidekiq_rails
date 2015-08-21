require 'sidekiq'
require 'sidekiq-status/web'


Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://127.0.0.1:6380' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://127.0.0.1:6380' }
end

Sidekiq.configure_client do |config|
  config.client_middleware do |chain|
    chain.add Sidekiq::Status::ClientMiddleware
  end
end

Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.add Sidekiq::Status::ServerMiddleware, expiration: 30.minutes # default
  end
  config.client_middleware do |chain|
    chain.add Sidekiq::Status::ClientMiddleware
  end
end

schedule_file = "config/scheduler.yml"

if File.exists?(schedule_file)
  Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
end
