FactoryBot.define do
  factory :event do
    title { 'タイトル' }
    start_time { '2021-08-30' }
    place { '富山' }
    body { '特になし' }
    user_id { FactoryBot.create(:user).id }
    
    after(:build) do |event|
      event.image.attach(io: File.open('spec/fixtures/files/test_image.jpg'), filename: 'test_image.jpg', content_type: 'image/jpg')
    end
  end
end