require 'rails_helper'

RSpec.describe 'ポスト投稿機能', type: :system do
  describe '一覧表示機能' do
    before do
      user_a = FactoryBot(:user, name: '江口', email: 'a@example.com')
      FactoryBot.create(:post, title: '最初のブログ', user: user_a)
    end
  end

  context 'ユーザーAがログインしている時' do
    before do
      visit new_user_session_path
      fill_in 'user_email', with: 'a@example.com'
      fill_in 'user_password', with: 'password'
      click_button 'Log in'
      visit user_posts_path
    end

    it 'ユーザーAが作成したブログが表示される' do
      expect(page).to have_content '最初のブログ'
    end
  end
end