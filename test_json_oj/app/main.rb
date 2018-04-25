require 'grape'
require 'grape-entity'
require 'oj'
require 'pry'

module GrapeEntityOJ
  def to_json( options = nil )
    Oj.dump serializable_hash.to_h, mode: :compat
  end
end

module GrapeEntityDSLOJ
  def to_json( options = nil )
    Oj.dump entity.serializable_hash.to_h, mode: :compat
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
    include GrapeEntityOJ

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
      include GrapeEntityOJ

      expose :id
      expose :title
      expose :content
    end
  end

  # --- Method 3
  class PostModel
    include Grape::Entity::DSL
    include GrapeEntityOJ
    include GrapeEntityDSLOJ

    attr_accessor :id, :title, :content, :dt

    def initialize( attributes = {} )
      attributes.each do |k, v|
        send "#{k}=", v
      end
    end

    entity :id, :title, :content
  end

  # ---
  class Main < Grape::API
    version 'v1', using: :path
    format :json
    prefix :api
    rescue_from :all

    resource :posts do
      get do  # /api/v1/posts
        if params[:m] == '2'  # /api/v1/posts?m=2
          puts '>>> Method 2'
          posts = [
            Post.new({ id: 1, title: 'A test', content: 'Just some content', dt: Date.today }),
            Post.new({ id: 2, title: 'Another test', content: 'Some other content', dt: Date.yesterday }),
            Post.new({ id: 3, title: 'Last test', content: 'The final content', dt: Date.tomorrow }),
          ]
          present posts, only: [:id, :title]
        elsif params[:m] == '3'  # /api/v1/posts?m=3
          puts '>>> Method 3'
          posts = [
            PostModel.new({ id: 1, title: 'A test', content: 'Just some content', dt: Date.today }),
            PostModel.new({ id: 2, title: 'Another test', content: 'Some other content', dt: Date.yesterday }),
            PostModel.new({ id: 3, title: 'Last test', content: 'The final content', dt: Date.tomorrow }),
          ]
          present posts, only: [:id, :title]
        else
          puts '>>> Method 1'
          posts = [
            OpenStruct.new({ id: 1, title: 'A test', content: 'Just some content', dt: Date.today }),
            OpenStruct.new({ id: 2, title: 'Another test', content: 'Some other content', dt: Date.yesterday }),
            OpenStruct.new({ id: 3, title: 'Last test', content: 'The final content', dt: Date.tomorrow }),
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
        when 3
          PostModel.new({ id: 3, title: 'Last test', content: 'The final content', dt: Date.tomorrow })
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
