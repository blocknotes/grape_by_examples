require 'grape-entity'

# A book
class MyAPI::Book
  include Mongoid::Document
  include Mongoid::Timestamps

  # Fields
  field :title, type: String
  field :description, type: String
  field :pages, type: Integer
  field :price, type: Float
  field :dt, type: DateTime

  validates :title, presence: true

  class Entity < Grape::Entity
    expose :id, :title, :description, :pages
  end
end
