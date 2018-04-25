# Grape Session Cookie

RubyDoc: [http://www.rubydoc.info/gems/rack/Rack/Session/Cookie](http://www.rubydoc.info/gems/rack/Rack/Session/Cookie)

*Rack::Session::Cookie provides simple cookie based session management. By default, the session is a Ruby Hash stored as base64 encoded marshalled data set to :key (default: rack.session). The object that encodes the session data is configurable and must respond to encode and decode. Both methods must take a string and return a string.*

- In **config.ru** add (see options in *config.rb*):
`use Rack::Session::Cookie, options`

- Initialize cookie session:
`Rack::Session::Cookie.new( self, secret: A_SECRET )`

- Get a coookie:
`env['rack.session'][:a_key]`

- Set a coookie:
`env['rack.session'][:a_key] = 123`
