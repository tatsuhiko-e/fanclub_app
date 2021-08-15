
FactoryBot.define do
    factory :post do
        title { 'タイトル' }

        after(:build) do |post|
          post.image.attach(io: File.open('spec/fixtures/files/test_image.jpg'), filename: 'test_image.jpg', content_type: 'image/jpg')
        end
    end
end