# config.ru (run with rackup)

require 'rack/cors'
use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: [:get, :post, :put, :delete, :options]
  end
end

require './app/main'

run MyAPI::Main
