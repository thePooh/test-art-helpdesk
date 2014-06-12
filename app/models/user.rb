class User
  include Mongoid::Document

  has_many :tickets, inverse_of: 'assignee'

  devise :database_authenticatable

  ## Database authenticatable
  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""

  field :name, type: String

  ROLES = [:member, :admin]

  field :role, type: Symbol, default: :member

  ROLES.each do |role|
    class_eval <<-eos
      def #{role}?
        self.role == :#{role}
      end
    eos
  end


  # From all the hacks, it seemed the best one.
  # Furthermore, it does not properly work with tests. *facepalm.jpg*
  # https://github.com/plataformatec/devise/issues/2949
  unless Rails.env.test?
    class << self
      def serialize_from_session(key, salt)
        record = to_adapter.get(key[0]["$oid"])
        record if record && record.authenticatable_salt == salt
      end
    end
  end
end
