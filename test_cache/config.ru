require './app/config'
require './app/main'
require 'rack/cache'

use Rack::Cache, MyAPI::CACHE

use Rack::ETag

run MyAPI::Main
