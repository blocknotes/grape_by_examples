require 'grape'
require 'pry'

class MyAPI::Main < Grape::API
  version 'v1', using: :path
  format :json
  prefix :api
  rescue_from :all

  before do  # Before every request
    if request.get?
      header 'Cache-Control', MyAPI::CACHE_CONTROL
    end
  end

  resource :posts do
    get do  # /api/v1/posts
      ## Example for a collection tu use Last-Modified in place of Etag:
      # header 'Last-Modified', rows.max_by{ |k, v| p k.updated_at }.updated_at.httpdate
      puts '>>> A new GET request...'
      { data: "GET - Time: #{Time.now}" }
    end

    post do  # /api/v1/posts
      puts '>>> A new POST request...'
      { data: "POST - Time: #{Time.now}" }
    end
  end

  route :any, '*path' do
    error!( 'not found', 404 )
  end
end
