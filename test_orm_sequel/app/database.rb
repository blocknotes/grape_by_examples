require 'sequel'
require 'sqlite3'

class MyAPI::Database
  class << self
    def init
      db = Sequel.connect( "sqlite://#{MyAPI::DB_FILE}" )
      Sequel::Model.plugin :association_pks
      Sequel::Model.plugin :json_serializer
      Sequel::Model.plugin :nested_attributes
      Sequel::Model.plugin :timestamps
      Sequel::Model.plugin :validation_helpers
      db
    end
  end
end

DB = MyAPI::Database.init unless defined? DB
