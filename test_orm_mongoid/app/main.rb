require 'grape'
require 'pry'

Dir['./app/models/*.rb'].each { |file| require file }

class MyAPI::Main < Grape::API
  format :json
  prefix :api
  version 'v1', using: :path
  rescue_from :all

  # books API
  resource :books do
    # TEST: curl -v 'http://127.0.0.1:3000/api/v1/books'
    get do  # /api/v1/books
      rows = MyAPI::Book.all
      present rows
    end

    # TEST: curl -v 'http://127.0.0.1:3000/api/v1/books/...'
    params do
      requires :id, type: String, desc: 'The id'
    end
    get ':id' do  # /api/v1/books/:id
      row = MyAPI::Book.find params[:id]
      present row
    end

    # TEST: curl -v -X POST 'http://127.0.0.1:3000/api/v1/books' --data 'title=Test1'
    params do
      requires :title, type: String, desc: 'The title'
    end
    post do  # /api/v1/books
      row = MyAPI::Book.create title: params[:title]
      present row
    end

    # TEST: curl -v -X PATCH 'http://127.0.0.1:3000/api/v1/books/...' --data 'title=Test2'
    params do
      requires :id, type: String, desc: 'The id'
      requires :title, type: String, desc: 'The title'
    end
    patch ':id' do  # /api/v1/books/:id
      row = MyAPI::Book.find params[:id]
      row.title = params[:title]
      row.save
      present row
    end

    # TEST: curl -v -X DELETE 'http://127.0.0.1:3000/api/v1/books/...'
    params do
      requires :id, type: String, desc: 'The id'
    end
    delete ':id' do  # /api/v1/books/:id
      row = MyAPI::Book.find params[:id]
      row.destroy
      present({ status: :ok })
    end
  end

  route :any, '*path' do
    error!( 'not found', 404 )
  end
end
