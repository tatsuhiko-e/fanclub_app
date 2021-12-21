class ContactMailer < ApplicationMailer
  def send_mail(contact)
    @contact = contact
    mail from: User.find(@contact.user_id).email , to:   @contact.to_email, subject: '【お問い合わせ】' + @contact.message
  end
end
