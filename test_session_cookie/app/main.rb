require 'grape'
require 'pry'

module MyAPI
  class Main < Grape::API
    version 'v1', using: :path
    format :json
    prefix :api
    rescue_from :all

    Rack::Session::Cookie.new( self, secret: MyAPI::SESSION_COOKIE[:secret] )

    get '/test' do  # /api/v1/test
      if !env['rack.session'][:a_key] || env['rack.session'][:a_key].empty?
        puts '>>> Invalid cookie! - SET'
        env['rack.session'][:a_key] = 'a_value'
        { message: "Cookie set - value: #{env['rack.session'][:a_key]}" }
      else
        puts '<<< Valid cookie - GET'
        { message: "Cookie get - value: #{env['rack.session'][:a_key]}" }
      end
    end

    route :any, '*path' do
      error!( 'not found', 404 )
    end
  end
end
