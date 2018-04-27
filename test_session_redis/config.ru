require './app/config'
require './app/main'
require 'rack/session/redis'

use Rack::Session::Redis, MyAPI::SESSION_REDIS

run MyAPI::Main
