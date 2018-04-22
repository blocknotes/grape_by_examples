# config.ru (run with rackup)

## Launch with:
# rackup -o 0.0.0.0 -p 3000

require './app/config'
require './app/main'
require 'rack/cache'

use Rack::Cache,
  metastore:   'file:/tmp/rack_cache_meta',
  entitystore: 'file:/tmp/rack_cache_body',
  verbose:     true
use Rack::ETag

run MyAPI::Main
