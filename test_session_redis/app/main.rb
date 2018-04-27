require 'grape'
require 'rack/session/redis'
require 'pry'

module MyAPI
  class Main < Grape::API
    version 'v1', using: :path
    format :json
    prefix :api
    rescue_from :all

    Rack::Session::Redis.new( self )

    get '/test' do  # /api/v1/test
      if !env['rack.session'][:an_object] || env['rack.session'][:an_object].empty?
        puts '>>> Invalid cookie! - SET'
        env['rack.session'][:an_object] = {
          a_var: 1,
          a_list: [ 3, 2, 1 ],
          an_hash: {
            key1: 123,
            key2: '456',
            key3: true
          }
        }
        { message: "Cookie set - value: #{env['rack.session'][:an_object].inspect}" }
      else
        puts '<<< Valid cookie - GET'
        { message: "Cookie get - value: #{env['rack.session'][:an_object].inspect}" }
      end
    end

    route :any, '*path' do
      error!( 'not found', 404 )
    end
  end
end
