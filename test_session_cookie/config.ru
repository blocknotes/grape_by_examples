require './app/config'
require './app/main'

use Rack::Session::Cookie, MyAPI::SESSION_COOKIE

run MyAPI::Main
