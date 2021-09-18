require 'rails_helper'

RSpec.describe Video, type: :model do
  it "タイトルとyoutube_urlがあれば投稿できる" do 
    expect(FactoryBot.create(:video)).to be_valid
  end

  it "タイトルがないと登録できない" do
    expect(FactoryBot.build(:video, title: "")).to_not be_valid
  end

  it "タイトルが20文字より多いと登録できない" do
    expect(FactoryBot.build(:video, title: "a"*21)).to_not be_valid
  end

  it "youtube_urlがないと登録できない" do
    expect(FactoryBot.build(:video, youtube_url: "")).to_not be_valid
  end
end
