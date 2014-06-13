class TicketsController < ApplicationController
  before_action :authenticate_user!, except: [:new, :show]
  before_action :load_ticket, only: [:show, :assign, :cancel, :hold, :complete]
  before_action :check_assigned, only: [:cancel, :hold, :complete]

  helper_method :assigned_to_user?

  def index
    params[:state] ||= :submitted
    @tickets = Ticket.all
    @tickets = @tickets.where(state: params[:state]) unless params[:state] == 'all'
    @tickets = @tickets.page(params[:page])
  end

  def show
  end

  def assign
    @ticket.assignee = current_user
    @ticket.assign!
    redirect_to :back
  end

  def hold
    @ticket.hold!
    redirect_to :back
  end

  def cancel
    @ticket.cancel!
    redirect_to :back
  end

  def complete
    @ticket.complete!
    redirect_to :back
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

  def assigned_to_user? ticket
    current_user.present? && (ticket.assignee == current_user)
  end

  private

  def load_ticket
    @ticket = Ticket.find_by(uid: params[:id])
  end

  def check_assigned
    unless assigned_to_user? @ticket
      flash[:alert] = t 'site.errors.unassigned'
      redirect_to :root
    end
  end

  def permitted_params
    params.require(:ticket).permit(:user_name, :user_email, :department_id, :subject, :body)
  end
end
