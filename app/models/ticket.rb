class Ticket
  include Mongoid::Document

  embeds_many :screenshots
  belongs_to :department

  # Submitter info
  # TODO: Think about extracting to a separate class and indexing
  field :user_email, type: String
  field :user_name, type: String

  # TODO: generate, index
  field :uid, type: String

  # Ticket data
  field :subject, type: String
  field :body, type: String

  field :state, type: Symbol

  STATES = [:submitted, :waiting, :hold, :cancelled, :completed]

  # state_machine :state, default: :submitted do
  #   # TODO: Fill in
  # end
end
