# Grape Warden

Using session cookie (Pool) and auth token.

- Add to **Gemfile**:
`gem 'warden'`

- Add a before authenticate to some routes:
```rb
before do
  env['warden'].authenticate!
end
```

- See **auth.rb**

## Curl tests

### Using cookie

- Login:
`curl -v -X POST 'http://127.0.0.1:3000/api/v1/tokens' --data 'username=Mat&password=123456' --cookie-jar '/tmp/cookie.txt'`

- Protected resource:
`curl -v 'http://127.0.0.1:3000/api/v1/authors' --cookie '/tmp/cookie.txt'`

- Logout:
`curl -v -X DELETE 'http://127.0.0.1:3000/api/v1/tokens' --cookie '/tmp/cookie.txt'`

### Stateless

- Login:
`curl -v -X POST 'http://127.0.0.1:3000/api/v1/tokens' --data 'username=Mat&password=123456'`

- Protected resource:
`curl -v 'http://127.0.0.1:3000/api/v1/authors?auth_token=...'`

- Protected resource (using header):
`curl -v 'http://127.0.0.1:3000/api/v1/authors' --header 'auth_token: ...'`

- Logout:
`curl -v -X DELETE 'http://127.0.0.1:3000/api/v1/tokens' --data 'auth_token=...'`

- Logout (using header):
`curl -v -X DELETE 'http://127.0.0.1:3000/api/v1/tokens' --header 'auth_token: ...'`
