# Grape Session Pool

RubyDoc: [http://www.rubydoc.info/gems/rack/Rack/Session/Pool](http://www.rubydoc.info/gems/rack/Rack/Session/Pool)

*Rack::Session::Pool provides simple cookie based session management. Session data is stored in a hash held by @pool. In the context of a multithreaded environment, sessions being committed to the pool is done in a merging manner.*

- In **config.ru** add (see options in *config.rb*):
`use Rack::Session::Pool, options`

- Initialize pool session:
`Rack::Session::Pool.new( self, secret: A_SECRET )`

- Get a coookie:
`env['rack.session'][:a_key]`

- Set a coookie:
`env['rack.session'][:a_key] = 123`
