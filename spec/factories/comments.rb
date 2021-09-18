FactoryBot.define do
  factory :comment do
    content { 'コメント' }
    association :post
    user { post.user }
  end
end