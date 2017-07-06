class StatementMailer < ApplicationMailer
  def submitted(email)
    mail(to: email, subject: 'Your submission to the Modern Slavery Registry')
  end
end
