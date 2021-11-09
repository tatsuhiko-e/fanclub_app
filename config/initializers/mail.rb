ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
:address => "smtp.gmail.com", 
:domain => "gmail.com",
:port => 587,
# user_name は自分のメールアドレスを記載。
:user_name => ENV["ESMTP_ADDRESS"],
# password は作成したアプリパスワードを記載。
:password => ENV["ESMTP_PASSWORD"],
:authentication => "plain",
:enable_starttls_auto => true
}