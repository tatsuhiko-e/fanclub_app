require 'rails_helper'

RSpec.describe '', type: :system do
  let!(:user_a) { FactoryBot.create(:user, email: 'aaa@example.com', name:'江口aa')}
  let!(:user_b) { FactoryBot.create(:user, email: 'bbb@example.com', name:'江口b', admin: false)}
  let!(:user_c) { FactoryBot.create(:user, email: 'ccc@example.com', name:'江口c')}


  describe '一覧表示機能' do
    context '管理者aがログインしている時' do
      let(:login_user) { user_a }

      before do
        sign_in_as(login_user)
        visit users_path
      end
   
      it 'ファンクラブ一覧が表示される' do
        expect(page).to have_content '江口c'
      end
    end

    context '一般ユーザーbがログインしている時' do
      let(:login_user) { user_b }

      before do
        sign_in_as(login_user)
        visit users_path
      end
   
      it 'ファンクラブ一覧が表示される' do
        expect(page).to have_content '江口c'
      end
    end

    context 'ログインしていない時' do
      before do
        visit users_path
      end
   
      it 'ファンクラブ一覧が表示される' do
        expect(page).to have_content '江口c'
      end
    end
  end

  describe 'ユーザー新規作成・ログアウト・編集・削除機能' do
    context 'userを新規作成する' do
      before do
        visit new_user_registration_path
        fill_in "user[name]",	with: "user_admin" 
        fill_in "user[email]",	with: "useradmin@exsample.com" 
        fill_in "user[password]",	with: "useradmin" 
        fill_in "user[password_confirmation]",	with: "useradmin" 
        click_button 'commit'
      end

      it  '本人確認メールが届く' do
        expect(ActionMailer::Base.deliveries.size).to eq 1
      end
    end

    context 'ユーザー削除機能' do
      
    end
  end

  describe 'user show ページ' do
    context '管理者aがログインしている時' do
      let(:login_user) { user_a }

      before do
        sign_in_as(login_user)
        visit user_path(login_user)
      end
   
      it 'ファンクラブが表示される' do
        expect(page).to have_content '江口a'
        expect(page).to have_content '近日のイベント'
        expect(page).to have_content 'メンバーを追加する'
      end
    end

    context '管理者aが一般ユーザーbのプロフィールを見ている時' do
      let(:login_user) { user_a }

      before do
        sign_in_as(login_user)
        visit user_path(user_b)
      end
   
      it 'ファンクラブが表示され投稿ボタンは表示されない' do
        expect(page).to have_content '江口b'
        expect(page).to have_no_content 'お気に入り投稿'
        expect(page).to have_content '北海道'
      end
    end

    context '一般ユーザーbのプロフィールが表示される' do
      let(:login_user) { user_b }

      before do
        sign_in_as(login_user)
        visit user_path(login_user)
      end
   
      it 'マイページが表示される' do
        expect(page).to have_content '江口b'
        expect(page).to have_content '北海道'
        expect(page).to have_content 'お気に入り投稿'
      end
    end

    context '一般ユーザーbがaのファンクラブを見ている時' do
      let(:login_user) { user_b }

      before do
        sign_in_as(login_user)
        visit user_path(user_a)
      end
   
      it 'ファンクラブが表示され投稿ボタンは表示されない' do
        expect(page).to have_content '江口a'
        expect(page).to have_no_content 'メンバーを追加する'
        expect(page).to have_content '近日のイベント'
      end
    end

    context 'ログインしていないuserがファンクラブを見ている時' do
      before do
        visit user_path(user_a)
      end
   
      it 'ファンクラブが表示される' do
        expect(page).to have_content '江口a'
        expect(page).to have_content '近日のイベント'
        expect(page).to have_no_content 'メンバーを追加する'
      end
    end

    context 'ログインしていないuserが一般ユーザーの詳細ページにアクセスした時' do
      before do
        visit user_path(user_b)
      end
   
      it 'ファンクラブが表示される' do
        expect(page).to have_content '新規ファンクラブ'
        expect(page).to have_content 'ファンクラブを作る方はこちら'
        expect(page).to have_no_content '近くのアイドル'
      end
    end
  end

  describe "編集機能" do
    context "管理者aが編集する時" do
      let(:login_user) { user_a }
      before do
        sign_in_as(login_user)
        visit edit_user_path(login_user)

        fill_in "user[name]",	with: "編集後"
        select(value = "2", from: "user[theme]") 
        click_button 'commit'
      end
      it "名前が編集後に編集される" do
        expect(page).to have_content '編集後'
      end
    end
  end

  context "一般ユーザーbが編集する時" do
    let(:login_user) { user_b }
    before do
      sign_in_as(login_user)
      visit edit_user_path(login_user)

      fill_in "user[name]",	with: "編集後"
      click_button 'commit'
    end
    it "名前が編集後に編集される" do
      expect(page).to have_content '編集後'
    end
  end

  context "ログインしていないユーザー編集リンクにアクセスした時" do
    before do
      visit edit_user_path(user_a)
    end
    it "ログインリンクにリダイレクト" do
      expect(page).to have_content 'ログインもしくはアカウント登録してください'
    end
  end

  context "別のユーザーの編集リンクにアクセスした時" do
    let(:login_user) { user_b }
    before do
      sign_in_as(login_user)
      visit edit_user_path(user_a)
    end
    it "rootページにリダイレクトされる" do
      expect(page).to have_content 'アイメモへようこそ'
    end
  end

  describe "ユーザーアカウント削除機能" do
    context "管理者aがアカウントを削除した時" do
      let(:login_user) { user_a }
      before do
        sign_in_as(login_user)
        visit edit_user_path(login_user)
        execute_script('window.scrollBy(0,10000)')
        click_link 'アカウントの削除'
        page.driver.browser.switch_to.alert.accept
      end
      it "アカウントが削除されマイページにリダイレクトされる" do
        expect(page).to have_content 'あなたの日常に一つの楽しみを'
        expect(User.where(name: '江口aa').count).to eq 0
      end
    end

    context "一般ユーザーbがアカウントを削除した時" do
      let(:login_user) { user_b }
      before do
        sign_in_as(login_user)
        visit edit_user_path(login_user)
        execute_script('window.scrollBy(0,10000)')
        click_link 'アカウントの削除'
        page.driver.browser.switch_to.alert.accept
      end
      it "アカウントが削除されマイページにリダイレクトされる" do
        expect(page).to have_content 'あなたの日常に一つの楽しみを'
        expect(User.where(name: '江口b').count).to eq 0
      end
    end
  end
end
