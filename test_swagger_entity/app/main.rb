require 'grape'
require 'grape-entity'
require 'grape-swagger'
require 'pry'

module MyAPI
  class PostEntity < Grape::Entity
    include MyAPI::OjSerialize

    expose :id
    expose :title
    expose :content
  end

  class Main < Grape::API
    version 'v1', using: :path
    format :json
    prefix :api

    rescue_from :all do |e|
      raise e
      error_response(message: "Internal server error: #{e}", status: 500)
    end

    before do
      header['Access-Control-Allow-Origin'] = '*'
      header['Access-Control-Request-Method'] = '*'
    end

    desc 'API Root'
    get do
      {
        posts_url: '/posts'
      }
    end

    resource :posts do
      desc 'List of posts'
      get do  # /api/v1/posts
        posts = [
          OpenStruct.new({ id: 1, title: 'A test', content: 'Just some content', dt: Date.today }),
          OpenStruct.new({ id: 2, title: 'Another test', content: 'Some other content', dt: Date.yesterday }),
        ]
        PostEntity.represent posts, only: [:id, :title]
      end

      desc 'Details of a post'
      params do
        requires :id, type: Integer, desc: 'The id'
      end
      get ':id' do  # /api/v1/posts/:id
        post = case params[:id]
          when 1 then OpenStruct.new({ id: 1, title: 'A test', content: 'Just some content', dt: Date.today })
          when 2 then OpenStruct.new({ id: 2, title: 'Another test', content: 'Some other content', dt: Date.yesterday })
          else nil
        end
        post.to_h
      end
    end

    route :any, '*path' do
      error!( 'not found', 404 )
    end

    add_swagger_documentation  # /api/v1/swagger_doc
  end
end
