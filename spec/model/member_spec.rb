require 'rails_helper'

RSpec.describe Member, type: :model do
  it "名前と画像があれば投稿できる" do 
    expect(FactoryBot.create(:member)).to be_valid
  end

  it "画像がなければ投稿できない" do 
    member = Member.new(name: "aaa")
    expect(member).to_not be_valid
  end 

  it "タイトルがないと登録できない" do
    expect(FactoryBot.build(:member, name: "")).to_not be_valid
  end

  it "タイトルが25文字より多いと登録できない" do
    expect(FactoryBot.build(:member, name: "a"*26)).to_not be_valid
  end

  it "プロフィール文が500文字より多いと登録できない" do
    expect(FactoryBot.build(:member, profile: "a"*501)).to_not be_valid
  end
end
