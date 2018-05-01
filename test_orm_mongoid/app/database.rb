require 'mongoid'

module MyAPI
  Mongoid.logger.level = Logger::DEBUG
  Mongoid.load!(File.expand_path('../database.yml', __dir__), (ENV['RACK_ENV'] || 'development').to_sym)
end
