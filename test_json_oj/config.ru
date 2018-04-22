# config.ru (run with rackup)

## Launch with:
# rackup -o 0.0.0.0 -p 3000

require './app/config'
require './app/main'

run MyAPI::Main
