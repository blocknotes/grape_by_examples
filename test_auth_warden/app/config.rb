module MyAPI
  AUTH_SESSION = {
    key: '_grape_session',
    domain: '127.0.0.1',
    path: '/',
    expire_after: 30,  # 30 seconds for testing
    secret: '123bc4f94b4ace96d4f87916f2fdd1b4d5ac1801f1439c74e9522bc28f14694bbbec6509900e1cf287700c7c783bee986af12956ea9ea7b5b02a26f0cfa8c398',
    # old_secret: 'an_old_secret'
  }

  TOKEN_DURATION = 30.freeze  # seconds
end
