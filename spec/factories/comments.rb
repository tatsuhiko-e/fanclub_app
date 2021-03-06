FactoryBot.define do
  factory :comment do
    content { 'コメント' }
    user_id { FactoryBot.create(:user).id }
    post_id { FactoryBot.create(:post).id }
  end
end