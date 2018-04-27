module MyAPI
  CACHE_CONTROL = 'max-age=30; public'.freeze  # 30 seconds just for testing
  CACHE = {
    metastore:   'file:/tmp/rack_cache_meta',
    entitystore: 'file:/tmp/rack_cache_body',
    verbose:     true
  }
end
