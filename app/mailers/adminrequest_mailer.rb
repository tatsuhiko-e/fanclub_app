class AdminrequestMailer < ApplicationMailer
  def send_mail(adminrequest)
    @adminrequest = adminrequest
    mail(
      from: 'system@example.com',
      to:   ENV["SMTP_ADDRESS"],
      subject: 'お問い合わせ通知'
    )
  end
end
