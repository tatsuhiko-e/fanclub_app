require 'rails_helper'

RSpec.describe 'ポスト投稿・編集・削除機能', type: :system do
  let(:user_a) { FactoryBot.create(:user, email: 'aaa@example.com', name:'江口a')}
  let(:user_b) { FactoryBot.create(:user, email: 'bbb@example.com', name:'江口b', admin: false)}
  let!(:post_a) { FactoryBot.create(:post, title: '最初のポスト', user: user_a) }

  describe '一覧表示機能' do
    before do  
      FactoryBot.create(:post, title: '最初のポスト', user: user_a)
    end

    context '管理者Aがログインしているとき' do
      let(:login_user) { user_a }

      before do
        sign_in_as(login_user)
        visit user_posts_path(login_user)
      end
   
      it 'ファンクラブが表示される' do
        expect(page).to have_selector("img[src$='test_image2.jpg']")
      end 
    end

    context '一般ユーザーBがログインしているとき' do
      let(:login_user) { user_b }

      before do  
        sign_in_as(login_user)
        visit user_posts_path(login_user)
      end

      it 'ファンクラブが表示されない' do
        expect(page).to have_no_content '近日のイベント'
        expect(page).to have_selector("img[src$='test_image3.jpg']")
      end 
    end

    context 'ログインしていないとき' do
      before do  
        visit user_path(user_a)
      end
      it 'ファンクラブが表示される' do
        expect(page).to have_content '近日のイベント'
        expect(page).to have_selector("img[src$='test_image2.jpg']")
      end 
    end
  end

  describe '新規作成機能' do
    context '管理者aがログインしている時' do
      let(:login_user) { user_a }

      before do
        sign_in_as(login_user)

        visit new_post_path
        fill_in 'post[title]', with: 'aaa'
        attach_file 'post[image]', "#{Rails.root}/spec/fixtures/files/test_image.jpg"
        click_button 'commit'
      end
      it '画像付きで投稿成功' do
        expect(page).to have_content 'aaa'
        expect(page).to have_selector("img[src$='test_image.jpg']")
      end
    end

    context '一般ユーザーbがログインしている時' do
      let(:login_user) { user_b }

      before do
        sign_in_as(login_user)
        visit new_post_path
      end
      it 'マイページが表示される' do
        expect(page).to have_content '江口b'
        expect(page).to have_current_path(user_path(login_user))
      end
    end
  end

  describe 'post詳細ページ' do
    context '管理者Aがログインしているとき' do
      let(:login_user) { user_a }

      before do
        sign_in_as(login_user)
        visit post_path(post_a)
      end
  
      it '削除・編集リンクが表示される' do
        expect(page).to have_content '最初のポスト'
        expect(page).to have_selector("img[src$='test_image2.jpg']")
        expect(page).to have_content 'このメッセージを削除する'
        expect(page).to have_content 'このメッセージを編集する'
      end 
    end

    context '一般ユーザーBがログインしているとき' do
      let(:login_user) { user_b }
      before do
        sign_in_as(login_user)
        visit post_path(post_a)
      end

      it '削除・編集リンクが表示されない' do
        expect(page).to have_content '最初のポスト'
        expect(page).to have_selector("img[src$='test_image2.jpg']")
        expect(page).to have_no_content 'このメッセージを削除する'
        expect(page).to have_no_content 'このメッセージを編集する'
      end 
    end

    context 'ログインしていないとき' do
      before do
        visit post_path(post_a)
      end

      it 'アカウント新規作成ページへリダイレクトする' do
        expect(page).to have_content 'ログイン'
      end
    end
  end

  describe 'post編集' do
    context '管理者Aがログインしているとき' do
      let(:login_user) { user_a }
      before do
        sign_in_as(login_user)
        visit post_path(post_a)
        click_link 'このメッセージを編集する'
        fill_in 'post[title]', with: '編集後'
        click_button '更新する'
      end
  
      it '削除・編集リンクが表示される' do
        expect(page).to have_content '編集後'
      end 
    end
  
    context '一般ユーザーBがログインしているとき' do
      let(:login_user) { user_b }
      before do
        sign_in_as(login_user)
        visit post_path(post_a)
      end
  
      it 'root_pathにリダイレクト' do
        expect(page).to have_no_content 'タイトル'
      end 
    end
  
    context 'ログインしていないとき' do
      before do
        visit edit_post_path(post_a)
      end
  
      it 'ログインページにリダイレクト' do
        expect(page).to have_content 'ログイン'
      end
    end
  end

  describe 'post削除' do
    context '管理者Aがログインしているとき' do
      let(:login_user) { user_a }
      before do
        sign_in_as(login_user)
  
        visit post_path(post_a)
        click_link 'このメッセージを削除する'
        page.driver.browser.switch_to.alert.accept 
      end
  
      it '投稿が削除される' do
        expect(page).to have_no_selector("img[src$='test_image.jpg']")
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
        visit edit_post_path(post_a)
      end
  
      it 'ログインページにリダイレクト' do
        expect(page).to have_content 'ログイン'
      end
    end
  end
end