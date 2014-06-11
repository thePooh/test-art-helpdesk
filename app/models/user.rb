class User
  include Mongoid::Document

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

  # From all the hacks...
  # https://github.com/plataformatec/devise/issues/2949
  class << self
    def serialize_from_session(key, salt)
      record = to_adapter.get(key[0]["$oid"])
      record if record && record.authenticatable_salt == salt
    end
  end
end
