FactoryBot.define do
  factory :post do
    title { 'タイトル' }
    user_id { FactoryBot.create(:user).id }

    after(:build) do |post|
      post.image.attach(io: File.open('spec/fixtures/files/test_image2.jpg'), filename: 'test_image2.jpg', content_type: 'image/jpg')
    end
  end
end