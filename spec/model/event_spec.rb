require 'rails_helper'

RSpec.describe Event, type: :model do
  it 'タイトルと開始時間と画像があれば投稿できる' do
    expect(FactoryBot.create(:event)).to be_valid
  end

  it 'タイトルがないと投稿できない' do
    expect(FactoryBot.build(:event, title: "")).to_not be_valid 
  end

  it 'タイトルが15文字以上だと投稿できない' do
    expect(FactoryBot.build(:event, title: "a"*16)).to_not be_valid 
  end

  it '開始時間がないと投稿できない' do
    expect(FactoryBot.build(:event, start_time: "")).to_not be_valid
  end

  it 'bodyが200文字以上だと投稿できない' do
    expect(FactoryBot.build(:event, body: "a"*201)).to_not be_valid 
  end

  it "画像がなければ投稿できない" do 
    event = Event.new(title: "aaa", start_time: "2021-08-30")
    expect(event).to_not be_valid
  end 
end
