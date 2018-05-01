require 'securerandom'

class MyAPI::Auth
  class << self
    def init(app)
      app.instance_eval do
        use Warden::Manager do |manager|
          manager.default_strategies :token
          manager.failure_app = ->( env ) {
            [401, { 'Content-Type' => 'application/json' }, [{ error: env['warden'].message || 'Unauthorized' }.to_json]]
          }
        end
      end

      Warden::Strategies.add(:token) do
        def valid?
          env['HTTP_AUTH_TOKEN'] || env['rack.request.query_hash']['AUTH_TOKEN']
        end

        def authenticate!
          token = valid?
          user = MyAPI::User.find(token: token)
          if user
            if user.token_updated_at > (Time.now - MyAPI::TOKEN_DURATION)
              MyAPI::User.update user.id, { token_updated_at: Time.now }
              success!(user)
            else
              MyAPI::User.update user.id, { token: nil }
              fail!('Token expired')
            end
          else
            fail!('Could not log in')
          end
        end
      end
    end

    def setup_routes(app)
      app.instance_eval do
        # TEST: curl -v -X POST 'http://127.0.0.1:3000/api/v1/tokens/register' --data 'username=Test'
        params do
          requires :username, type: String, desc: 'Login username'
        end
        post '/register' do  # /api/v1/tokens/register
          user = MyAPI::Auth.sign_up(params)
          user ? user.to_h : { error: 'Invalid access' }
        end

        # TEST: curl -v -X POST 'http://127.0.0.1:3000/api/v1/tokens' --data 'username=Mat'
        params do
          requires :username, type: String, desc: 'Login username'
        end
        post do  # /api/v1/tokens
          user = MyAPI::Auth.sign_in(params.slice(:username).symbolize_keys)
          user ? user.to_h : { error: 'Invalid access' }
        end

        # TEST: curl -v -X DELETE 'http://127.0.0.1:3000/api/v1/tokens' --data 'token=aaa'
        params do
          requires :token, type: String, desc: 'Auth token'
        end
        delete do  # /api/v1/tokens
          user = MyAPI::Auth.sign_out(params.slice(:token).symbolize_keys)
          user ? user.to_h : { error: 'Invalid access' }
        end
      end
    end

    def sign_in(user_data)
      user = MyAPI::User.find user_data
      if user
        user = MyAPI::User.update user.id, { token: SecureRandom.urlsafe_base64(80, false), token_updated_at: Time.now }
        return user.to_h if user
      end
    end

    def sign_out(user_data)
      user = MyAPI::User.find user_data
      if user
        user = MyAPI::User.update user.id, { token: nil }
        return user.to_h if user
      end
    end

    def sign_up(user_data)
      user = MyAPI::User.create user_data
      if user
        user = MyAPI::User.update user.id, { token: SecureRandom.urlsafe_base64(80, false), token_updated_at: Time.now }
        return user.to_h if user
      end
    end
  end
end
