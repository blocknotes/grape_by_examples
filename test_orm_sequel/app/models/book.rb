require 'sequel'
require 'grape-entity'

DB.create_table :books do
  primary_key :id
  String :title
end if defined?(DB) && ENV['MIGRATING']

class MyAPI::Book < Sequel::Model
  class Entity < Grape::Entity
    expose :id, :title
  end

  plugin :timestamps, update_on_create: true
end
