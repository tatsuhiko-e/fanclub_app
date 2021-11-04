class AdminrequestMailer < ApplicationMailer
  def send_mail(adminrequest)
    @adminrequest = adminrequest
    mail(
      from: 'system@example.com',
      to:   ENV['TOMAIL'],
      subject: 'お問い合わせ通知'
    )
  end
end
