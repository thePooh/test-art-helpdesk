class History
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  belongs_to :ticket
  belongs_to :user

  field :from_state, type: Symbol
  field :to_state, type: Symbol

  after_create :send_email

  private

  #TODO: Extract to observer
  def send_email
    TicketMailer.ticket_updated self
  end
end
