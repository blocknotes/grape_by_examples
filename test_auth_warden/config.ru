require_relative 'app/config'
require_relative 'app/main'
require 'warden'

if defined? MyAPI::AUTH_SESSION
  use Rack::Session::Pool, MyAPI::AUTH_SESSION
end

run MyAPI::Main
