# Preview all emails at http://localhost:3000/rails/mailers/adminrequest_mailer
class AdminrequestMailerPreview < ActionMailer::Preview
  def adminrequest
    adminrequest = Adminrequest.new(teamname: "侍 太郎", twitter_url: "https://.com/", user_id: 1)
    AdminrequestMailer.send_mail(adminrequest)
  end
end
