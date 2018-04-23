# rackup -p 3000

require 'grape'
require 'grape-entity'
require 'oj'
require 'pry'

module MyAPI::OjSerialize
  def to_json( options = nil )
    Oj.dump serializable_hash.to_h, mode: :compat
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

  before do
    header 'Content-Type', 'application/json'
  end

  resource :posts do
    get do  # /api/v1/posts
      posts = [OpenStruct.new({ id: 1, title: 'A test', content: 'Just some content', dt: Date.today })]
      MyAPI::PostEntity.represent posts, only: [:id, :title]
    end

    params do
      requires :id, type: Integer, desc: 'The id'
    end
    get ':id' do  # /api/v1/posts/:id
      post = OpenStruct.new({ id: 1, title: 'A test', content: 'Just some content', dt: Date.today })
      MyAPI::PostEntity.represent post
    end
 end

  route :any, '*path' do
    error!( 'not found', 404 )
  end
end
