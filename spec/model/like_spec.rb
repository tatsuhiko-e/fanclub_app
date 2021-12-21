require 'rails_helper'

RSpec.describe Like, type: :model do
  let(:like) { FactoryBot.create(:like) }
  describe '#create' do
    context "保存できる場合" do
      it "全てのパラメーターが揃っていれば保存できる" do
        expect(like).to be_valid
      end
    end

    context "保存できない場合" do
      it "user_idがnilの場合は保存できない" do
        like.user_id = nil
        expect(like).to_not be_valid
      end

      it "followed_idがnilの場合は保存できない" do
        like.post_id = nil
        expect(like).to_not be_valid
      end
    end

    context "一意性の検証" do
      before do
        @like1 = FactoryBot.create(:like)
        @user1 = FactoryBot.build(:like)
      end

      it "user_idとpost_idの組み合わせは一意でなければ保存できない" do
        like2 = FactoryBot.build(:like, user_id: @like1.user_id, post_id: @like1.post_id)
        like2.valid?
        expect(like2).to be_invalid
      end

      it "user_idが同じでもpost_idが違うなら保存できる" do
        like2 = FactoryBot.build(:like, user_id: @like1.user_id, post_id: @user1.post_id)
        expect(like2).to be_valid
      end

      it "user_idが違うならpost_idが同じでも保存できる" do
        like2 = FactoryBot.build(:like, user_id: @user1.user_id, post_id: @like1.post_id)
        expect(like2).to be_valid
      end
    end
  end


  describe "各モデルとのアソシエーション" do
    let(:association) do
      described_class.reflect_on_association(target)
    end

    context "仮想モデルfollowerとのアソシエーション" do
      let(:target) { :user }

      it "Followerとの関連付けはbelongs_toであること" do
        expect(association.macro).to  eq :belongs_to
      end
    end

    context "仮想モデルfollowedとのアソシエーション" do
      let(:target) { :post }

      it "Followとの関連付けはbelongs_toであること" do
        expect(association.macro).to  eq :belongs_to
      end
    end
  end
end
