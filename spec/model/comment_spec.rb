require 'rails_helper'

RSpec.describe Comment, type: :model do
  it "コメントがあれば投稿できる" do 
    expect(FactoryBot.create(:comment)).to be_valid
  end

  it "タイトルが60文字より多いと登録できない" do
    expect(FactoryBot.build(:comment, content: "a"*61)).to_not be_valid
  end

  it "コメントが空だと投稿できない" do
    expect(FactoryBot.build(:comment, content: "")).to_not be_valid
  end
end
