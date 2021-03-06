require 'grape'
require 'warden'
require 'pry'
require_relative 'config'
require_relative 'user'
require_relative 'auth'

class MyAPI::Main < Grape::API
  format :json
  prefix :api
  version 'v1', using: :path
  # rescue_from :all

  # if defined? MyAPI::AUTH_SESSION
  #   use Rack::Session::Pool, MyAPI::AUTH_SESSION
  #   Rack::Session::Pool.new( self, secret: MyAPI::AUTH_SESSION[:secret] )
  # end
  # Rack::Session::Pool.new( self, secret: MyAPI::AUTH_SESSION[:secret] )

  MyAPI::Auth.init(self)

  resource :tokens do
    MyAPI::Auth.setup_routes(self)
  end

  # TEST: curl -v 'http://127.0.0.1:3000/api/v1/authors' --header 'auth_token: aaa'
  resource :authors do
    before do
      env['warden'].authenticate!
    end
    get do  # /api/v1/authors
      { message: "Some authors - User: #{env['warden'].user.id}" }
    end
  end

  # TEST: curl -v 'http://127.0.0.1:3000/api/v1/posts' --header 'auth_token: aaa'
  resource :posts do
    before do
      env['warden'].authenticate!
    end
    get do  # /api/v1/posts
      { message: "Some posts - User: #{env['warden'].user.id}" }
    end
  end

  route :any, '*path' do
    error!( 'not found', 404 )
  end
end
