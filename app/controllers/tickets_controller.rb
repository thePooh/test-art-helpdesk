class TicketsController < ApplicationController
  before_action :authenticate_user!, only: [:index]

  def index
  end

  def show
  end

  def new
    @ticket = Ticket.new
  end

  def create
    ticket = Ticket.new params.require(:ticket).permit!
    if ticket.save
      flash.notice = t('ticket.info.created')
    else
      flash.alert = t('ticket.info.failed')
    end
    redirect_to :root
  end
end
