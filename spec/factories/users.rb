FactoryBot.define do
  factory :user do
    name {'江口'}
    sequence(:email) { |n| "test#{n}@example.com" }
    password {'password'}
    password_confirmation {'password'}
    confirmed_at { Date.today }
    area { 1 }
    gender { 0 }
    profile {'aaaaaaaaaaaaa'}
    
    admin true
    
    after(:build) do |user|
      user.image.attach(io: File.open('spec/fixtures/files/test_image3.jpg'), filename: 'test_image3.jpg', content_type: 'image/jpeg')
    end
  end
end
