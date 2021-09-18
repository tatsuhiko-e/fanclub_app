require 'rails_helper'

RSpec.describe 'member投稿・編集・削除機能', type: :system do
  let(:user_a) { FactoryBot.create(:user, email: 'aaa@example.com', name:'江口a') }
  let(:user_b) { FactoryBot.create(:user, email: 'bbb@example.com', name:'江口b', admin: false) }
  let!(:member_a) { FactoryBot.create(:member, name: 'human', user: user_a) }

  describe '一覧表示機能' do
    context '管理者aがログインしているとき' do
      let(:login_user) { user_a }
      before do
        sign_in_as(login_user)
        visit user_path(user_a)
      end

      it '投稿ボタンとイベント一覧が表示される' do      
        expect(page).to have_content 'メンバーを追加する'
        expect(page).to have_content 'member'
      end
    end

    context '一般ユーザーがログインしているとき' do
      let(:login_user) { user_b }
      before do
        sign_in_as(login_user)
        visit user_path(user_a)
      end
    
      it '投稿ボタンが表示されない' do
        expect(page).to have_no_content 'メンバーを追加する'
      end
    end

    context 'ログインしていないとき' do
      before do
        visit user_path(user_a)
      end 

      it '投稿ボタンが表示されない' do
        expect(page).to have_no_content 'メンバーを追加する'
      end
    end
  end

  describe '新規作成機能' do
    context '管理者aがログインしているとき' do
      let(:login_user) { user_a }

      before do
        sign_in_as(login_user)

        visit new_member_path
        attach_file 'member[image]', "#{Rails.root}/spec/fixtures/files/test_image.jpg"
        fill_in 'member[name]', with: '人'
        click_button 'commit'
      end
      it '投稿成功' do
        expect(page).to have_content '人'
        expect(page).to have_selector("img[src$='test_image.jpg']")
      end
    end

    context "一般ユーザーbがログインしているとき" do
      let(:login_user) { user_b }
      before do
        sign_in_as(login_user)

        visit new_member_path
      end
      it 'マイページにリダイレクト' do
        expect(page).to have_content '江口b'
        expect(page).to have_content '北海道'
      end
    end

    context 'ログインしていないとき' do
      before do
        visit new_member_path
      end
      it 'ログインページにリダイレクト' do
        expect(page).to have_content 'ログインもしくはアカウント登録してください。'
      end
    end
  end

  describe'イベント詳細ページ' do
    context '管理者aがログインしているとき' do
      let(:login_user) { user_a }
      before do
        sign_in_as(login_user)
        visit member_path(member_a)
      end

      it '編集リンクと削除リンクが表示される' do
        expect(page).to have_content '削除'
        expect(page).to have_content '編集'
      end
    end

    context ' 一般ユーザーbがログインしているとき' do
      let(:login_user) { user_b }
      before do
        sign_in_as(login_user)
        visit member_path(member_a)
      end

      it '編集リンクと削除リンクが表示されない' do
        expect(page).to have_no_content '削除'
        expect(page).to have_no_content '編集'
      end
    end

    context 'ログインしていないとき' do
      before do
        visit member_path(member_a)
      end

      it 'ログインページにリダイレクトにリダイレクトされる' do
        expect(page).to have_content 'ログインもしくはアカウント登録してください。'
      end
    end
  end

  describe'イベント編集' do
    context '管理者aがログインしているとき' do
      let(:login_user) { user_a }

      before do
        sign_in_as(login_user)
        visit member_path(member_a)
        click_link '編集'
        fill_in 'member[name]', with: '編集済'
        click_button 'commit'
      end

      it '編集済に編集される' do
        expect(page).to have_content '編集済'
        expect(page).to have_selector("img[src$='test_image.jpg']")
      end
    end

    context '一般ユーザーbがログインしているとき' do
      let(:login_user) { user_b }

      before do
        sign_in_as(login_user)
        visit edit_member_path(member_a)
      end

      it 'マイページにリダイレクトされる' do
        expect(page).to have_content '江口b'
      end
    end

    context '一般ユーザーbがログインしているとき' do
      before do
        visit edit_member_path(member_a)
      end

      it 'ログインページにリダイレクトにリダイレクトされる' do
        expect(page).to have_content 'ログインもしくはアカウント登録してください。'
      end
    end
  end

  describe "削除" do
    context "管理者aがログインしている時" do
      let(:login_user) { user_a }
      before do
        sign_in_as(login_user)
  
        visit member_path(member_a)
        click_link '削除'
        page.driver.browser.switch_to.alert.accept 
      end
  
      it '投稿が削除される' do
        expect(page).to have_no_content 'human'
      end 
    end
  end
end