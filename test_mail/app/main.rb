require 'grape'
require 'pry'
require 'mail'

class MyAPI::Main < Grape::API
  version 'v1', using: :path
  format :json
  prefix :api
  rescue_from :all

  get '/test' do  # /api/v1/test
    begin
      Mail.new do
        from     'from_address'
        to       'to_address'
        subject  'Just a test...'
        body     'A test body'
      end.deliver!
      { status: 'ok' }
    rescue Exception => e
      { error: e.message }
    end
  end

  route :any, '*path' do
    error!( 'not found', 404 )
  end
end
