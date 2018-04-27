require './app/config'
require './app/main'
require 'rack/cache'
require 'redis-rack-cache'

use Rack::Cache, MyAPI::SESSION_REDIS

use Rack::ETag

run MyAPI::Main
