FactoryBot.define do
  factory :member do
    name { 'aaa' }
    profile { 'bbbbbbbb' }
    association :user

    after(:build) do |member|
      member.image.attach(io: File.open('spec/fixtures/files/test_image.jpg'), filename: 'test_image.jpg', content_type: 'image/jpg')
    end
  end
end
  