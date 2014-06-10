class Department
  include Mongoid::Document

  field :name, type: String

  has_many :tickets
  has_many :users
end
