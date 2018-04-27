# Using Redis for cache with Grape

GitHub: [https://github.com/redis-store/redis-rack-cache](https://github.com/redis-store/redis-rack-cache)

- Added to **Gemfile**:
`gem 'redis-rack-cache'`

- Updated **config.ru** with:
```rb
require 'redis-rack-cache'
use Rack::Cache,
  metastore: 'redis://localhost:6379/0/metastore',
  entitystore: 'redis://localhost:6379/1/entitystore'
```
