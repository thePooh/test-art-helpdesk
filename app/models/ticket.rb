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

  field :state, type: Symbol, default: :submitted

  STATES = [:submitted, :waiting, :hold, :cancelled, :completed]

  def files= files
    files.each do |file|
      screenshots.create(image: file)
    end
  end

  state_machine :state do
    # TODO: Fill in
  end

  private
  def generate_uid
    # TODO: generate random
    self.uid = 3
  end
end
