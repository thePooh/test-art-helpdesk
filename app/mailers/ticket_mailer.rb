class TicketMailer < ActionMailer::Base
  default :from => 'helpdesk@test.com'

  def ticket_created ticket
    @ticket = ticket
    mail(to: ticket.user_email, subject: t('mail.created.subject', uid: ticket.uid))
  end

  def ticket_updated history
    @history = history
    @user = history.user
    @ticket = history.ticket
    mail(to: @ticket.user_email, subject: t('mail.updated.subject', name: @user.name, uid: @ticket.uid))
  end
end
