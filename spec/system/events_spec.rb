require 'rails_helper'

RSpec.describe 'event投稿・編集・削除機能', type: :system do
  let(:user_a) { FactoryBot.create(:user, email: 'aaa@example.com', name:'江口a') }
  let(:user_b) { FactoryBot.create(:user, email: 'bbb@example.com', name:'江口b', admin: false) }
  let!(:event_a) { FactoryBot.create(:event, title: '最初のイベント', user: user_a) }

  describe '一覧表示機能' do
    context '管理者aがログインしているとき' do
      let(:login_user) { user_a }

      before do
        sign_in_as(login_user)
        visit user_events_path(user_a)
      end

      it '投稿ボタンとイベント一覧が表示される' do
        expect(page).to have_content 'イベント投稿'
        expect(page).to have_content '月 火 水 木 金 土 日'
      end
    end

    context '一般ユーザーがログインしているとき' do
      let(:login_user) { user_b }
      before do
        sign_in_as(login_user)
        visit user_events_path(user_a)
      end
    
      it '投稿ボタンが表示されない' do
        expect(page).to have_no_content 'イベント投稿'
      end
    end

    context 'ログインしていないとき' do
      before do
        visit user_events_path(user_a)
      end 

      it '投稿ボタンが表示されない' do
        expect(page).to have_no_content 'イベント投稿'
      end
    end
  end


  describe '新規作成機能' do
    context '管理者aがログインしているとき' do
      let(:login_user) { user_a }

      before do
        sign_in_as(login_user)

        visit new_event_path
        attach_file 'event[image]', "#{Rails.root}/spec/fixtures/files/test_image.jpg"
        select(value = "2021", from: "event[start_time(1i)]") 
        select(value = "8", from: "event[start_time(2i)]") 
        select(value = "26", from: "event[start_time(3i)]") 
        select(value = "07", from: "event[start_time(4i)]") 
        select(value = "30", from: "event[start_time(5i)]") 
        fill_in 'event[title]', with: '握手会'
        fill_in 'event[place]', with: '東京'
        fill_in 'event[body]', with: 'aaa'

        click_button 'commit'
      end
      it '画像付きで投稿成功' do
        expect(page).to have_content '握手会'
        expect(page).to have_content '8月26日'
        expect(page).to have_selector("img[src$='test_image.jpg']")
      end
    end

    context "一般ユーザーbがログインしているとき" do
      let(:login_user) { user_b }
      before do
        sign_in_as(login_user)

        visit new_event_path
      end
      it 'マイページにリダイレクト' do
        expect(page).to have_content '江口b'
        expect(page).to have_no_content '最初のイベント'
      end
    end

    context 'ログインしていないとき' do
      before do
        visit new_event_path
      end
  
      it 'ログインページにリダイレクト' do
        expect(page).to have_content 'ログイン'
      end
    end
  end

  describe'イベント詳細ページ' do
    context '管理者aがログインしているとき' do
      let(:login_user) { user_a }
      before do
        sign_in_as(login_user)
        visit event_path(event_a)
      end

      it '編集リンクと削除リンクが表示される' do
        expect(page).to have_content 'このメッセージを削除する'
        expect(page).to have_content 'このメッセージを編集する'
      end
    end

    context ' 一般ユーザーbがログインしているとき' do
      let(:login_user) { user_b }
      before do
        sign_in_as(login_user)
        visit event_path(event_a)
      end

      it '編集リンクと削除リンクが表示されない' do
        expect(page).to have_no_content 'このメッセージを削除する'
        expect(page).to have_no_content 'このメッセージを編集する'
      end
    end

    context ' ログインしていないとき' do
      before do
        visit event_path(event_a)
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
        visit event_path(event_a)
        click_link 'このメッセージを編集する'

        attach_file 'event[image]', "#{Rails.root}/spec/fixtures/files/test_image.jpg"
        select(value = "2021", from: "event[start_time(1i)]") 
        select(value = "8", from: "event[start_time(2i)]") 
        select(value = "26", from: "event[start_time(3i)]") 
        select(value = "07", from: "event[start_time(4i)]") 
        select(value = "30", from: "event[start_time(5i)]") 
        fill_in 'event[title]', with: '握手会'
        fill_in 'event[place]', with: '東京'
        fill_in 'event[body]', with: '編集済'

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
        visit edit_event_path(event_a)
      end

      it 'マイページにリダイレクトされる' do
        expect(page).to have_content '江口b'
      end
    end

    context '一般ユーザーbがログインしているとき' do
      before do
        visit edit_event_path(event_a)
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
  
        visit event_path(event_a)
        click_link 'このメッセージを削除する'
        page.driver.browser.switch_to.alert.accept 
      end
  
      it '投稿が削除される' do
        expect(page).to have_no_content '最初のイベント'
      end 
    end

    context '一般ユーザーBがログインしているとき' do
      let(:login_user) { user_b }
      before do
        sign_in_as(login_user)
      end
  
      it 'マイページにリダイレクト' do
        expect(page).to have_content '江口b'
        expect(page).to have_no_content 'タイトル'
      end 
    end

    context 'ログインしていないとき' do
      before do
        visit edit_event_path(event_a)
      end

      it 'ログインページにリダイレクト' do
        expect(page).to have_content 'ログイン'
      end
    end
  end
end
