# Grape Cache

GitHub: [https://github.com/rtomayko/rack-cache](https://github.com/rtomayko/rack-cache)

- Added to **Gemfile**:
`gem 'rack-cache'`

- Updated **config.ru** with:
```rb
require 'rack/cache'

use Rack::Cache,
  metastore:   'file:/tmp/rack_cache_meta',
  entitystore: 'file:/tmp/rack_cache_body',
  verbose:     true
use Rack::ETag
```

- Added a *before* block for every GET request:
`header 'Cache-Control', 'max-age=3600; public' if request.get?`
