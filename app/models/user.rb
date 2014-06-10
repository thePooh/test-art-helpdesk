class User
  include Mongoid::Document

  devise :database_authenticatable

  ## Database authenticatable
  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""

  ROLES = [:member, :admin]

  field :role, type: Symbol, default: :member

  ROLES.each do |role|
    class_eval <<-eos
      def #{role}?
        self.role == :#{role}
      end
    eos
  end
end
