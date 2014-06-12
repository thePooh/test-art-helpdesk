class TicketsController < ApplicationController
  before_action :authenticate_user!, only: [:index]

  def index
    params[:state] ||= :submitted
    @tickets = Ticket.all
    @tickets = @tickets.where(state: params[:state]) unless params[:state] == 'all'
    @tickets = @tickets.page(params[:page])
  end

  def show
    @ticket = Ticket.find params[:id]
  end

  def new
    @ticket = Ticket.new
  end

  def create
    ticket = Ticket.new permitted_params

    files = params[:ticket][:files]
    ticket.files = files if files.present?
    if ticket.save
      # TODO: Investigate rails 4 mailer
      TicketMailer.ticket_created ticket
      flash.notice = t('ticket.info.created')
    else
      flash.alert = t('ticket.info.failed')
    end
    redirect_to :root
  end

  private

  def permitted_params
    params.require(:ticket).permit(:user_name, :user_email, :department_id, :subject, :body)
  end
end
