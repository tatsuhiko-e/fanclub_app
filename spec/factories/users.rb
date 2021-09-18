FactoryBot.define do
  factory :user do
    name {'江口'}
    sequence(:email) { |n| "test#{n}@example.com" }
    password {'password'}
    area {'北海道'}
    profile {'aaaaaaaaaaaaa'}
    gender {'男'}
    admin true

    after(:create) {|user| user.confirm}

    after(:build) do |user|
      user.image.attach(io: File.open('spec/fixtures/files/test_image3.jpg'), filename: 'test_image3.jpg', content_type: 'image/jpg')
    end
  end
end
