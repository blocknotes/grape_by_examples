require 'grape'
require 'warden'
require 'pry'
require_relative 'auth'

class User
  attr_accessor :id

  class << self
    def find( attributes )
      if attributes[:token] == 'aaa'  # TODO: testing...
        self.new.tap do |obj|
          obj.id = 1
        end
      elsif attributes[:id]
        self.new.tap do |obj|
          obj.id = attributes[:id]
        end
      end
    end
  end
end

class MyAPI::Main < Grape::API
  version 'v1', using: :path
  format :json
  prefix :api
  rescue_from :all

  use Rack::Session::Pool, MyAPI::SESSION

  Auth.init( self )

  # TEST1: curl -v 'http://127.0.0.1:3000/api/v1/posts' --header 'auth_token: aaa'
  resource :posts do
    before do
      env['warden'].authenticate!
    end
    # params do
    #   requires :username, type: String, desc: 'Login username'
    #   requires :password, type: String, desc: 'Login password'
    # end
    get do  # /api/v1/posts
      puts '>>> A new GET request...', env['warden'].user.inspect
      { data: "GET - Time: #{Time.now} - User: #{env['warden'].user.id}" }
    end
  end

  route :any, '*path' do
    error!( 'not found', 404 )
  end
end
