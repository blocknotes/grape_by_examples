require 'grape'
require 'grape-entity'
require 'oj'
require 'pry'

module MyAPI
  module OjSerialize
    def to_json( options = nil )
      Oj.dump serializable_hash.to_h, mode: :compat
    end
  end
end

class MyAPI::PostEntity < Grape::Entity
  include MyAPI::OjSerialize

  expose :id
  expose :title
  expose :content
end

class MyAPI::Main < Grape::API
  version 'v1', using: :path
  format :json
  prefix :api
  rescue_from :all

  resource :posts do
    get do  # /api/v1/posts
      posts = [
        OpenStruct.new({ id: 1, title: 'A test', content: 'Just some content', dt: Date.today }),
        OpenStruct.new({ id: 2, title: 'Another test', content: 'Some other content', dt: Date.yesterday }),
      ]
      MyAPI::PostEntity.represent posts, only: [:id, :title]
    end

    params do
      requires :id, type: Integer, desc: 'The id'
    end
    get ':id' do  # /api/v1/posts/:id
      post = case params[:id]
        when 1 then OpenStruct.new({ id: 1, title: 'A test', content: 'Just some content', dt: Date.today })
        when 2 then OpenStruct.new({ id: 2, title: 'Another test', content: 'Some other content', dt: Date.yesterday })
        else nil
      end
      MyAPI::PostEntity.represent post
    end
 end

  route :any, '*path' do
    error!( 'not found', 404 )
  end
end
