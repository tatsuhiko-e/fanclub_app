require 'rails_helper'

RSpec.describe 'ポスト投稿機能', type: :system do
  describe '一覧表示機能' do
    let(:user_a) { FactoryBot.create(:user, name: '江口a', email: 'a@example.com', area: '宮城県')}
    let(:user_b) { FactoryBot.create(:user, name: '江口b', email: 'b@example.com', admin: 'false', area: '宮城県')}

    before do
      FactoryBot.create(:post, title: '最初のポスト', user: user_a)

      visit new_user_session_path
      fill_in 'user[email]', with: 'a@example.com'
      fill_in 'user[password]', with: 'password'
      click_button 'Log in'
    end

    context 'ユーザーAがログインしている時' do
      let(:login_user) { user_a }


      it 'ユーザー詳細ページが表示される' do
        expect(page).to have_content '江口a'
      end
    end
  end

 
end