require 'rails_helper'

RSpec.describe 'video投稿・編集・削除機能', type: :system do
  let(:user_a) { FactoryBot.create(:user, email: 'aaa@example.com', name:'江口a') }
  let(:user_b) { FactoryBot.create(:user, email: 'bbb@example.com', name:'江口b', admin: false) }

  describe 'ファンクラブ開設申請（メール）' do
    context '一般ユーザーが申請しているとき' do
      let(:login_user) { user_b }
      before do
        sign_in_as(login_user)
        visit new_adminrequest_path

        fill_in "adminrequest[teamname]",	with: "a_fanclub"
        fill_in "adminrequest[twitter_url]",	with: "a.com"

        click_button 'commit'
        click_button '送信'
      end

      it '運営者にメールが送信される' do      
        expect(ActionMailer::Base.deliveries.size).to eq 1
      end
    end

    context '一般ユーザーが申請しているとき' do
      let(:login_user) { user_a }
      before do
        sign_in_as(login_user)
        visit new_adminrequest_path
      end

      it '運営者にメールが送信される表示される' do      
        expect(page).to have_content '江口a'
      end
    end

    context 'ログインしていないユーザーが申請するとき' do
      before do
          visit new_adminrequest_path
      end

      it 'ログインページにリダイレクトされる' do      
          expect(page).to have_content 'ログイン'
          expect(page).to have_content 'ログインしてからやり直してください'
      end
    end
  end
end
