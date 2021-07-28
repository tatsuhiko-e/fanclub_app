FactoryBot.define do
    factory :user do
      email {'test1@example.com'}
      password {'password'}
      area {'1'}
      admin true

      after(:build) do |user|
        user.image.attach(io: File.open('spec/fixtures/files/test_image.jpg'), filename: 'test_image.jpg', content_type: 'image/jpg')
      end
    end
  end