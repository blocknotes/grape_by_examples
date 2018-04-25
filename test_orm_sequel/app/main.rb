require 'grape'
require 'pry'

Dir['./app/models/*.rb'].each { |file| require file }

class MyAPI::Main < Grape::API
  version 'v1', using: :path
  format :json
  prefix :api
  rescue_from :all

  resource :posts do
    get do  # /api/v1/posts
      rows = MyAPI::Book.all
      present rows
    end

    params do
      requires :id, type: Integer, desc: 'The id'
    end
    get ':id' do  # /api/v1/posts/:id
      row = MyAPI::Book.first id: params[:id]
      present row
    end

    params do
      requires :title, type: String, desc: 'The title'
    end
    post do  # /api/v1/posts
      row = MyAPI::Book.create title: params[:title]
      present row
    end

    params do
      requires :id, type: Integer, desc: 'The id'
      requires :title, type: String, desc: 'The title'
    end
    patch ':id' do  # /api/v1/posts/:id
      row = MyAPI::Book.first id: params[:id]
      row.title = params[:title]
      row.save
      present row
    end

    params do
      requires :id, type: Integer, desc: 'The id'
    end
    delete ':id' do  # /api/v1/posts/:id
      row = MyAPI::Book.first id: params[:id]
      row.destroy
      present({ status: :ok })
    end
  end

  route :any, '*path' do
    error!( 'not found', 404 )
  end
end
