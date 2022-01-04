require 'rails_helper'

RSpec.describe 'コメント投稿、削除機能', type: :system do
  let(:user_a) { FactoryBot.create(:user, email: 'aaa@example.com', name:'江口a') }
  let(:user_b) { FactoryBot.create(:user, email: 'bbb@example.com', name:'江口b', admin: false) }
  let!(:post_a) { FactoryBot.create(:post, user: user_a, id: '1') }
  let!(:post_b) { FactoryBot.create(:post, user: user_a, id: '2') }
  let!(:comment_a) { FactoryBot.create(:comment,post_id: '2' ,user: user_b) }

  describe '表示機能' do
    context '管理者aがログインしているとき' do
      let(:login_user) { user_a }
      before do
        sign_in_as(login_user)
        visit post_path(2)
      end

      it 'aの投稿にbのコメントが表示される' do      
        expect(page).to have_content 'タイトル'
        expect(page).to have_content 'コメント'
      end
    end

    context '一般ユーザーがログインしているとき' do
      let(:login_user) { user_b }
      before do
        sign_in_as(login_user)
        visit post_path(2)
    end

    it 'aの投稿にbのコメントと削除機能が表示される' do      
      expect(page).to have_content 'タイトル'
      expect(page).to have_content 'コメント'
      expect(page).to have_content 'コメントを削除する'
    end
  end

    context 'ログインしていないとき' do
      before do
        visit post_path(2)
      end 

      it 'ログインページにリダイレクト' do
        expect(page).to have_content 'ログイン'
      end
    end
  end

  describe '新規作成機能' do
    context '管理者aがログインしているとき' do
      let(:login_user) { user_a }

      before do
        sign_in_as(login_user)
        visit post_path(1)
        fill_in 'comment[content]', with: 'コメント1'
        execute_script('window.scrollBy(0,10000)')
        click_button 'コメントする'
      end
      it '投稿成功(a)' do
        expect(page).to have_content 'コメント1'
        expect(page).to have_content 'コメントを削除する'
      end
    end

    context '一般ユーザーbがログインしているとき' do
      let(:login_user) { user_b }

      before do
        sign_in_as(login_user)
        visit post_path(1)

        fill_in 'comment[content]', with: 'コメント'
        execute_script('window.scrollBy(0,10000)')
        click_button 'commit'
        execute_script('window.scrollBy(10000,10000)')
      end
      it '投稿成功(b)' do
        expect(page).to have_content 'コメント'
        expect(page).to have_content 'コメントを削除する'
      end
    end
  end

  describe'コメント削除リンクの有無' do
    context '管理者aがログインしているとき' do
      let(:login_user) { user_a }

      before do
        sign_in_as(login_user)
        visit post_path(2)
      end
      it 'user_idの違う投稿は削除できない' do
        expect(page).to have_content 'コメント'
        expect(page).to have_no_content 'コメントを削除する'
      end
    end

    context '一般ユーザーbがログインしているとき' do
      let(:login_user) { user_b }

      before do
        sign_in_as(login_user)
        visit post_path(2)
      end
      it 'user_idが同じなら削除できる' do
        expect(page).to have_content 'コメント'
        expect(page).to have_content 'コメントを削除する'
      end
    end
  end


  describe'コメント削除機能' do
    context '管理者aがログインしているとき' do
      let(:login_user) { user_a }

      before do
        sign_in_as(login_user)
        visit post_path(1)
        fill_in 'comment[content]', with: 'コメント'
        execute_script('window.scrollBy(0,10000)')
        click_button 'コメントする'
        execute_script('window.scrollBy(0,10000)')
        click_link 'コメントを削除する'
        page.driver.browser.switch_to.alert.accept
      end
      it '削除できる(a)' do
        expect(page).to have_no_content 'コメント'
        expect(page).to have_no_content 'コメントを削除する'
      end
    end

    context '一般ユーザーbがログインしているとき' do
      let(:login_user) { user_b }

      before do
        sign_in_as(login_user)
        visit post_path(1)
        fill_in 'comment[content]', with: 'コメント'
        execute_script('window.scrollBy(0,10000)')
        click_button 'commit'
        execute_script('window.scrollBy(0,10000)')
        click_link 'コメントを削除する'
        page.driver.browser.switch_to.alert.accept
      end
      it '削除できる（b）' do
        expect(page).to have_no_content 'コメント'
        expect(page).to have_no_content 'コメントを削除する'
      end
    end
  end
end