class UserMailer < ApplicationMailer

  def success_email(user, transaction)
    @user = user
    @transaction = transaction
    mail(to: @user.email, subject: 'New Successful Transaction')
  end
end