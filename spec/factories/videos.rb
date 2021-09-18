FactoryBot.define do
  factory :video do
    user_id { FactoryBot.create(:user).id }
    title { 'タイトル' }
    youtube_url { 'https://www.youtube.com/watch?v=8nxaZ69ElEc' }
  end
end