require 'grape'
require 'warden'
require 'pry'
require_relative 'auth'

USERS = [
  {
    id: 1,
    username: 'Mat'
  },
  {
    id: 2,
    username: 'Jim'
  }
]  # SAMPLE DATA

class User
  # attr_accessor :id

  class << self
    def create(attributes)
      return nil unless attributes[:username]
      user = find username: attributes[:username]
      if user
        nil
      else
        user = {
          id: USERS.count + 1,
          username: attributes[:username]
        }
        USERS << user
        OpenStruct.new(user)
      end
    end

    def find(attributes)
      USERS.each do |user|
        return OpenStruct.new(user) if (attributes.to_a - user.to_a).empty?
      end
      nil
    end

    def update(id, attributes)
      USERS.each do |user|
        if user[:id] == id
          user.merge! attributes.dup.symbolize_keys
          return OpenStruct.new(user)
        end
      end
      nil
    end
  end
end

class MyAPI::Main < Grape::API
  version 'v1', using: :path
  format :json
  prefix :api
  rescue_from :all

  use Rack::Session::Pool, MyAPI::SESSION

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
