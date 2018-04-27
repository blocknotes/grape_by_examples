module MyAPI
  CACHE_CONTROL = 'max-age=30; public'.freeze  # 30 seconds just for testing
  SESSION_REDIS = {
    metastore: 'redis://localhost:6379/0/metastore',
    entitystore: 'redis://localhost:6379/1/entitystore'
  }
end
