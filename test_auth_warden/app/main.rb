require 'grape'
require 'warden'
require 'pry'
require_relative 'user'
require_relative 'auth'

class MyAPI::Main < Grape::API
  version 'v1', using: :path
  format :json
  prefix :api
  rescue_from :all

  # use Rack::Session::Pool, MyAPI::SESSION

  Auth.init(self)

  # TEST: curl -v -X POST 'http://127.0.0.1:3000/api/v1/register' --data 'username=Test'
  params do
    requires :username, type: String, desc: 'Login username'
  end
  post '/register' do  # /api/v1/register
    user = Auth.sign_up(params)
    user ? user.to_h : { error: 'Invalid access' }
  end

  resource :tokens do
    # TEST: curl -v -X POST 'http://127.0.0.1:3000/api/v1/tokens' --data 'username=Mat'
    params do
      requires :username, type: String, desc: 'Login username'
    end
    post do  # /api/v1/tokens
      user = Auth.sign_in(params.slice(:username).symbolize_keys)
      user ? user.to_h : { error: 'Invalid access' }
    end

    params do
      requires :token, type: String, desc: 'Auth token'
    end
    delete do  # /api/v1/tokens
      user = Auth.sign_out(params.slice(:token).symbolize_keys)
      user ? user.to_h : { error: 'Invalid access' }
    end
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
