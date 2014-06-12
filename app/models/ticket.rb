class Ticket
  include Mongoid::Document
  include Mongoid::Timestamps
  include StateMachine::Integrations::Mongoid

  embeds_many :screenshots
  belongs_to :department
  belongs_to :assignee, class_name: 'User'
  has_many :histories

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
  attr_accessor :prev_state

  STATES = [:submitted, :assigned, :holded, :cancelled, :completed]

  def files= files
    files.each do |file|
      screenshots.create(image: file)
    end
  end

  state_machine :state, initial: :submitted do
    event :assign do
      transition :submitted => :assigned
    end

    event :hold do
      transition :assigned => :holded
    end

    event :cancel do
      transition [:assigned, :holded] => :cancelled
    end

    event :complete do
      transition [:assigned, :holded] => :completed
    end

    before_transition do |object|
      object.prev_state = object.state
    end

    after_transition do |object|
      object.histories.create(from_state: object.prev_state, to_state: object.state, user: object.assignee)
    end
  end

  private
  def generate_uid
    # TODO: generate random
    self.uid = 3
  end
end
