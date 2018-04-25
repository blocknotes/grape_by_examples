require 'grape'
require 'grape-entity'
require 'oj'
require 'pry'

module GrapeEntitySerializable
  def to_json( options = nil )
    Oj.dump serializable_hash.to_h, mode: :compat
  end
end

module WithGrapeEntity
  def entity
    @entity ||= self.class::Entity.new self
  end

  def to_json( options = nil )
    entity.to_json options
  end
end

module MyAPI
  # --- Method 1
  class PostEntity < Grape::Entity
    include GrapeEntitySerializable

    expose :id
    expose :title
    expose :content
  end

  # --- Method 2
  class Post
    include WithGrapeEntity

    attr_accessor :id, :title, :content, :dt

    def initialize( attributes = {} )
      attributes.each do |k, v|
        send "#{k}=", v
      end
    end

    class Entity < Grape::Entity
      include GrapeEntitySerializable

      expose :id
      expose :title
      expose :content
    end
  end

  # ---
  class Main < Grape::API
    version 'v1', using: :path
    format :json
    prefix :api
    rescue_from :all

    resource :posts do
      get do  # /api/v1/posts
        if params[:m2]  # /api/v1/posts?m2=1
          puts '>>> Method 2'
          posts = [
            Post.new({ id: 1, title: 'A test', content: 'Just some content', dt: Date.today }),
            Post.new({ id: 2, title: 'Another test', content: 'Some other content', dt: Date.yesterday }),
          ]
          present posts, only: [:id, :title]
        else
          puts '>>> Method 1'
          posts = [
            OpenStruct.new({ id: 1, title: 'A test', content: 'Just some content', dt: Date.today }),
            OpenStruct.new({ id: 2, title: 'Another test', content: 'Some other content', dt: Date.yesterday }),
          ]
          MyAPI::PostEntity.represent posts, only: [:id, :title]
        end
      end

      params do
        requires :id, type: Integer, desc: 'The id'
      end
      get ':id' do  # /api/v1/posts/:id
        case params[:id]
        when 1
          MyAPI::PostEntity.represent OpenStruct.new({ id: 1, title: 'A test', content: 'Just some content', dt: Date.today })
        when 2
          MyAPI::Post.new({ id: 2, title: 'Another test', content: 'Some other content', dt: Date.yesterday })
        else
          {}
        end
      end
    end

    route :any, '*path' do
      error!( 'not found', 404 )
    end
  end
end
