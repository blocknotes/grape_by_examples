# config.ru (run with rackup)

require './app/config'
require './app/main'
require 'rack/cache'

use Rack::Cache,
  metastore:   'file:/tmp/rack_cache_meta',
  entitystore: 'file:/tmp/rack_cache_body',
  verbose:     true

use Rack::ETag

run MyAPI::Main
