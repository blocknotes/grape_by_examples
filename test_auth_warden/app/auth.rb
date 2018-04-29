module Auth
  def Auth.init( app )
    app.use Warden::Manager do |manager|
      manager.default_strategies :token
      manager.failure_app = ->( env ) {
        [401, { 'Content-Type' => 'application/json' }, [{ error: env['warden'].message || 'Unauthorized' }.to_json]]
      }
    end

    Warden::Strategies.add(:token) do
      def valid?
        env['HTTP_AUTH_TOKEN'] || env['rack.request.query_hash']['AUTH_TOKEN']
      end

      def authenticate!
        token = valid?
        user = User.find( token: token )
        user.nil? ? fail!("Could not log in") : success!(user)
      end
    end
  end

  def Auth.sign_in( user_data )
    user = User.find user_data
    if user
      user = User.update user.id, { token: 'aaa' }  # TODO: generate a valid token
      return user.to_h if user
    end
  end
end
