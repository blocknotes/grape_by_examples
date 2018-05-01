require 'securerandom'

class MyAPI::Auth
  class << self
    def init(app)
      Warden::Strategies.add(:token) do
        def valid?
          (params['username'] && params['password']) || params['auth_token'] || env['HTTP_AUTH_TOKEN'] || env['rack.request.query_hash']['AUTH_TOKEN']
        end

        def authenticate!
          if params['username'] && params['password']
            user = MyAPI::User.find params.symbolize_keys.slice(:username, :password)
            if user
              user.update({ token: SecureRandom.urlsafe_base64(80, false), token_updated_at: Time.now })
              success!(user)
            else
              fail!('Invalid credentials')
            end
          else
            token = params['auth_token'] || env['HTTP_AUTH_TOKEN'] || env['rack.request.query_hash']['AUTH_TOKEN']
            if token
              user = MyAPI::User.find(token: token)
              if user
                user.update({ token_updated_at: Time.now })
                success!(user)
              else
                fail!('Could not log in')
              end
            else
              fail!('Invalid access')
            end
          end
        end
      end

      app.instance_eval do
        use Warden::Manager do |config|
          # config.failure_app = self
          config.failure_app = ->( env ) {
            [401, { 'Content-Type' => 'application/json' }, [{ error: env['warden'].message || 'Unauthorized' }.to_json]]
          }
          config.scope_defaults :default,
            strategies: [:token],
            action: 'auth/unauthenticated'

          if defined? MyAPI::AUTH_SESSION
            config.serialize_into_session do |user|
              user.token
            end

            config.serialize_from_session do |token|
              MyAPI::User.find(token: token)
            end
          end
        end
      end
    end

    def setup_routes(app)
      app.instance_eval do
        # # TEST: curl -v -X POST 'http://127.0.0.1:3000/api/v1/tokens/register' --data 'username=Test'
        # params do
        #   requires :username, type: String, desc: 'Login username'
        # end
        # post '/register' do  # /api/v1/tokens/register
        #   user = MyAPI::Auth.sign_up(params)
        #   if user
        #     env['HTTP_AUTH_TOKEN'] = user.token
        #     return user.to_h if env['warden'].authenticate
        #   end
        #   { error: 'Invalid access' }
        # end

        # TEST: curl -v -X POST 'http://127.0.0.1:3000/api/v1/tokens' --data 'username=Mat&password=123456' --cookie-jar '/tmp/cookie.txt'
        params do
          requires :username, type: String, desc: 'Login username'
          requires :password, type: String, desc: 'Login password'
        end
        before do
          env['warden'].authenticate!
        end
        post do
          env['warden'].user.to_h
        end

        # TEST: curl -v -X DELETE 'http://127.0.0.1:3000/api/v1/tokens' --cookie '/tmp/cookie.txt'
        before do
          env['warden'].authenticate!
        end
        delete do  # /api/v1/tokens
          # p env['warden'].raw_session.inspect
          env['warden'].user.update({ token: nil, token_updated_at: nil })
          env['warden'].logout
          { status: 'ok' }
        end
      end
    end

    def sign_up(user_data)
      user = MyAPI::User.create user_data
      MyAPI::User.update user.id, { token: SecureRandom.urlsafe_base64(80, false), token_updated_at: Time.now } if user  # returns user data
    end
  end
end
