module MyAPI
  SESSION_REDIS = {
    expire_after: 30,  # 30 seconds for testing
    redis_server: 'redis://127.0.0.1:6379/0/my_rack_session'
  }
end
