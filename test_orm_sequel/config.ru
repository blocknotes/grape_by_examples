# config.ru (run with rackup)

require './app/config'
require './app/database'
require './app/main'

run MyAPI::Main
