# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
run Rails.application

require 'sidekiq/web'
use Rack::Session::Cookie, :secret => "some unique secret string here"
run Sidekiq::Web

