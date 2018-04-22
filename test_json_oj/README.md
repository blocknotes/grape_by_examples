# Grape OJ

- Added to **Gemfile**:
`gem 'oj'`

- Set formato to text:
`format :txt`

- Set content type for every request:
`header 'Content-Type', 'application/json'`

- Render data with:
`Oj.dump(h)`
