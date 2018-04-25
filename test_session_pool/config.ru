require './app/config'
require './app/main'

use Rack::Session::Pool, MyAPI::SESSION_POOL

run MyAPI::Main
