require 'rails_helper'

RSpec.describe 'Users', type: :system do
  before do
    @user = FactoryBot.create(:user)
    OmniAuth.config.mock_auth[:twitter] = nil
  end

  context 'Twitter認証ができるとき' do
    it 'ログインボタンを押してユーザーがTwitter認証を許可した時' do
      Rails.application.env_config['omniauth.auth'] = twitter_mock
      visit new_user_registration_path
      find_link('Twitterアカウントでログイン', href: '/users/auth/twitter').click # ログインボタンをクリックしてTwitter認証を行う

      expect(page).to have_content('お気に入り投稿') # リダイレクトされてTOPに戻るとログインできている
    end
  end
  context 'Twitter認証ができないとき' do
    it 'ログインボタンを押してユーザーがTwitter認証をキャンセルした時' do
      Rails.application.env_config['omniauth.auth'] = twitter_invalid_mock
      visit new_user_registration_path
      find_link('Twitterアカウントでログイン', href: '/users/auth/twitter').click # ログインボタンをクリックしてTwitter認証を行う
      expect(page).to_not have_content('お気に入り投稿') # リダイレクトされてTOPに戻るとログインできてない
    end
  end
end
