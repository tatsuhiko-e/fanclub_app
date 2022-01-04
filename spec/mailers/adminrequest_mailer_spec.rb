require "rails_helper"

RSpec.describe AdminrequestMailer, type: :mailer do
  describe "when to register free membership" do
    let!(:user_a) { FactoryBot.create(:user, email: 'bbb@example.com', name:'江口b', admin: false)}
  end
end
