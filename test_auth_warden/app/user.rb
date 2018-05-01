USERS = [
  {
    id: 1,
    username: 'Mat'
  },
  {
    id: 2,
    username: 'Jim'
  }
]  # SAMPLE DATA

module MyAPI
  class User
    # attr_accessor :id

    class << self
      def create(attributes)
        return nil unless attributes[:username]
        user = find username: attributes[:username]
        if user
          nil
        else
          user = {
            id: USERS.count + 1,
            username: attributes[:username]
          }
          USERS << user
          OpenStruct.new(user)
        end
      end

      def find(attributes)
        USERS.each do |user|
          return OpenStruct.new(user) if (attributes.to_a - user.to_a).empty?
        end
        nil
      end

      def update(id, attributes)
        USERS.each do |user|
          if user[:id] == id
            user.merge! attributes.dup.symbolize_keys
            return OpenStruct.new(user)
          end
        end
        nil
      end
    end
  end
end
