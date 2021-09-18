FactoryBot.define do
  factory :ticket do
    user_id { FactoryBot.create(:user).id }
    event_id { FactoryBot.create(:event).id }
  end
end