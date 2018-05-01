# Grape Warden

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

- Register:
`curl -v -X POST 'http://127.0.0.1:3000/api/v1/tokens/register' --data 'username=Test'`

- Login:
`curl -v -X POST 'http://127.0.0.1:3000/api/v1/tokens' --data 'username=Mat'`

- Logout:
`curl -v -X DELETE 'http://127.0.0.1:3000/api/v1/tokens' --data 'token=aaa'`

- Protected resource:
`curl -v 'http://127.0.0.1:3000/api/v1/posts' --header 'auth_token: aaa'`
