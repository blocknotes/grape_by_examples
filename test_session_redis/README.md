# Redis sessions with Grape

GitHub: [https://github.com/redis-store/redis-rack](https://github.com/redis-store/redis-rack)

- Add to **Gemfile**:
`gem 'redis-rack'`

- Add to **config.ru**:
```rb
require 'rack/session/redis'
use Rack::Session::Redis
```

- Initialize session in the app with:
`Rack::Session::Redis.new( self )`
