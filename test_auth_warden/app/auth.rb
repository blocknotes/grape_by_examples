module Auth
  def Auth.init( app )
    app.use Warden::Manager do |manager|
      manager.default_strategies :password
      manager.failure_app = ->( env ) {
        [401, { 'Content-Type' => 'application/json' }, [{ error: env['warden'].message || 'Unauthorized' }.to_json]]
      }
    end

    Warden::Manager.serialize_into_session do |object|
      object.id
    end

    Warden::Manager.serialize_from_session do |id|
      User.find( id: id )
    end

    Warden::Strategies.add(:password) do
      def valid?
        # p '[valid?]', params, env['AUTH_TOKEN']
        params['username'] && params['password']
      end

      def authenticate!
        # p '[authenticate!]', params
        u = User.find( username: params['username'], password: params['password'] )
        u.nil? ? fail!("Could not log in") : success!(u)
      end
    end
  end
end
