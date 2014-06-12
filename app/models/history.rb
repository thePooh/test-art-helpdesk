class History
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  belongs_to :ticket
  belongs_to :user

  field :from_state, type: Symbol
  field :to_state, type: Symbol

  #TODO: Extract to observer
  after_create :send_email, unless: -> { Rails.env.test? }

  private

  def send_email
    TicketMailer.ticket_updated self
  end
end
