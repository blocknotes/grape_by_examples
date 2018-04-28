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
