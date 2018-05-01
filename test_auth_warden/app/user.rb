USERS = [
  {
    id: 1,
    username: 'Mat',
    password: '123456'
  },
  {
    id: 2,
    username: 'Jim',
    password: 'abcdef'
  }
]  # SAMPLE DATA

module MyAPI
  class User
    FIELDS = [:id, :username, :password, :token, :token_updated_at].freeze
    attr_accessor *FIELDS

    def initialize( attributes = {} )
      set attributes
    end

    def set( attributes = {} )
      attributes.each do |k, v|
        self.send "#{k}=", v if FIELDS.include? k.to_sym
      end
      self
    end

    def to_h
      FIELDS.map do |f| [ f, self.send(f) ] end.to_h
    end

    def update(attributes)
      User.update self.id, attributes
      set attributes
    end

    class << self
      def create(attributes)
        return nil if !attributes[:username] || !attributes[:password]
        user = find username: attributes[:username], password: attributes[:password]
        if user
          nil
        else
          user = {
            id: USERS.count + 1,
            username: attributes[:username],
            password: attributes[:password]
          }
          USERS << user
          User.new(user)
        end
      end

      def find(attributes)
        USERS.each do |user|
          return User.new(user) if (attributes.to_a - user.to_a).empty?
        end
        nil
      end

      def update(id, attributes)
        USERS.each do |user|
          if user[:id] == id
            user.merge! attributes.dup.symbolize_keys
            return User.new(user)
          end
        end
        nil
      end
    end
  end
end
