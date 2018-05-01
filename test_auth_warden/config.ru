require_relative 'app/config'
require_relative 'app/main'
require 'warden'

use Rack::Session::Pool, MyAPI::AUTH_SESSION

run MyAPI::Main
