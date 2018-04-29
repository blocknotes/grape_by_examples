require 'grape'
require 'warden'
require 'pry'
require_relative 'auth'

USERS = [
  {
    id: 1,
    token: 'aaa'
  },
  {
    id: 2,
    token: 'bbb'
  }
]  # SAMPLE DATA

class User
  attr_accessor :id

  class << self
    def find( attributes )
      USERS.each do |user|
        return OpenStruct.new(user) if (attributes.to_a - user.to_a).empty?
      end
      nil
    end
  end
end

class MyAPI::Main < Grape::API
  version 'v1', using: :path
  format :json
  prefix :api
  # rescue_from :all

  use Rack::Session::Pool, MyAPI::SESSION

  Auth.init( self )

  # TEST1: curl -v 'http://127.0.0.1:3000/api/v1/authors' --header 'auth_token: aaa'
  resource :authors do
    before do
      env['warden'].authenticate!
    end
    get do  # /api/v1/authors
      puts '>>> A new GET request...', env['warden'].user.inspect
      { data: "Some authors - User: #{env['warden'].user.id}" }
    end
  end

  resource :posts do
    before do
      env['warden'].authenticate!
    end
    get do  # /api/v1/posts
      puts '>>> A new GET request...', env['warden'].user.inspect
      { data: "Some posts - User: #{env['warden'].user.id}" }
    end
  end

  route :any, '*path' do
    error!( 'not found', 404 )
  end
end
