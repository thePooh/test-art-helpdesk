class Ticket
  include Mongoid::Document
  include Mongoid::Timestamps
  include StateMachine::Integrations::Mongoid

  embeds_many :screenshots, cascade_callbacks: true
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

  field :reply, type: String

  field :state, type: Symbol
  attr_accessor :prev_state

  validates_uniqueness_of :uid
  before_validation :generate_uid, on: :create

  STATES = [:submitted, :assigned, :holded, :cancelled, :completed]

  def files= files
    files.each do |file|
      begin
        screenshots.build(image: file)
      rescue
        self.errors.add :screenshots, I18n.t('ticket.errors.image')
      end
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
  end

  before_update do
    if self.assignee_id_changed?
      self.histories.create(from_state: self.state, to_state: self.state, user: self.assignee)
    end
    if self.prev_state.present?
      $redis.publish 'state-change', {uid: self.uid, state: self.state}.to_json
      self.histories.create(from_state: self.prev_state, to_state: self.state, user: self.assignee)
    end
  end

  def to_param
    self.uid
  end

  private

  #TODO: find less ugly way to do this. This may be non-thread-safe
  def generate_uid
    def tri vals
      "#{vals.sample}#{vals.sample}#{vals.sample}"
    end
    chars = ("A".."Z").to_a
    numbers = ("0".."9").to_a
    self.uid = loop do
      uid = "#{tri(chars)}-#{tri(numbers)}-#{tri(chars)}-#{tri(numbers)}-#{tri(chars)}"
      break uid unless Ticket.where(uid: uid).exists?
    end
  end
end
