require 'rails_helper'

RSpec.describe Post, type: :model do
  it "タイトルと画像があれば投稿できる" do 
    expect(FactoryBot.create(:post)).to be_valid
  end

  it "画像がなければ投稿できない" do 
    post = Post.new(title: "aaa")
    expect(post).to_not be_valid
  end 

  it "タイトルがないと登録できない" do
    expect(FactoryBot.build(:post, title: "")).to_not be_valid
  end

  it "タイトルが15文字より多いと登録できない" do
    expect(FactoryBot.build(:post, title: "a"*16)).to_not be_valid
  end
end
