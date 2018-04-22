# rackup -p 3000

require 'grape'
require 'oj'
require 'pry'

class MyAPI::Main < Grape::API
  version 'v1', using: :path
  # format :json
  format :txt
  prefix :api
  rescue_from :all

  before do
    header 'Content-Type', 'application/json'
  end

  resource :posts do
    get do  # /api/v1/posts
      h = { 'one' => 1, 'array' => [ true, false ] }
      Oj.dump(h)
    end
  end

  route :any, '*path' do
    error!( 'not found', 404 )
  end
end
