require 'rails_helper'

RSpec.describe Ticket, type: :model do
  let(:ticket) { FactoryBot.create(:ticket) }
  describe '#create' do
    context "保存できる場合" do
      it "全てのパラメーターが揃っていれば保存できる" do
        expect(ticket).to be_valid
      end
    end

    context "保存できない場合" do
      it "user_idがnilの場合は保存できない" do
        ticket.user_id = nil
        expect(ticket).to_not be_valid
      end

      it "followed_idがnilの場合は保存できない" do
        ticket.event_id = nil
        expect(ticket).to_not be_valid
      end
    end

    context "一意性の検証" do
      before do
        @ticket1 = FactoryBot.create(:ticket)
        @user1 = FactoryBot.build(:ticket)
      end

      it "user_idとevent_idの組み合わせは一意でなければ保存できない" do
        ticket2 = FactoryBot.build(:ticket, user_id: @ticket1.user_id, event_id: @ticket1.event_id)
        ticket2.valid?
        expect(ticket2).to_not be_invalid
      end

      it "user_idが同じでもevent_idが違うなら保存できる" do
        ticket2 = FactoryBot.build(:ticket, user_id: @ticket1.user_id, event_id: @user1.event_id)
        expect(ticket2).to be_valid
      end

      it "follower_idが違うならfollowed_idが同じでも保存できる" do
        ticket2 = FactoryBot.build(:ticket, user_id: @user1.user_id, event_id: @ticket1.event_id)
        expect(ticket2).to be_valid
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
      let(:target) { :event }

      it "Followとの関連付けはbelongs_toであること" do
        expect(association.macro).to  eq :belongs_to
      end
    end
  end
end
