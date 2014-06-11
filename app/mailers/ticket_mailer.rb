class TicketMailer < ActionMailer::Base
  default :from => 'helpdesk@test.com'

  def ticket_created ticket
    @ticket = ticket
    mail(to: ticket.user_email, subject: t('mail.created.subject', id: ticket.uid))
  end
end
