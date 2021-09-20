require 'rails_helper'

RSpec.describe 'video投稿・編集・削除機能', type: :system do
  let(:user_a) { FactoryBot.create(:user, email: 'aaa@example.com', name:'江口a') }
  let(:user_b) { FactoryBot.create(:user, email: 'bbb@example.com', name:'江口b', admin: false) }
  let!(:video_a) { FactoryBot.create(:video, title: '最初のビデオ', user: user_a) }

  describe '一覧表示機能' do
    context '管理者aがログインしているとき' do
      let(:login_user) { user_a }
      before do
        sign_in_as(login_user)
        visit videos_user_path(user_a)
      end

      it '投稿ボタンとイベント一覧が表示される' do      
        expect(page).to have_content 'ムービーを追加する'
        expect(page).to have_content '最初のビデオ'
      end
    end

    context '一般ユーザーがログインしているとき' do
      let(:login_user) { user_b }
      before do
        sign_in_as(login_user)
        visit videos_user_path(user_a)
      end
    
      it '投稿ボタンが表示されない' do
        expect(page).to have_no_content 'ムービーを追加する'
      end
    end

    context 'ログインしていないとき' do
      before do
        visit events_user_path(user_a)
      end 

      it '投稿ボタンが表示されない' do
        expect(page).to have_no_content 'ムービーを追加する'
      end
    end


    describe '新規作成機能' do
      context '管理者aがログインしているとき' do
        let(:login_user) { user_a }

        before do
          sign_in_as(login_user)

          visit new_video_path
          fill_in 'video[title]', with: '動画投稿'
          fill_in 'video[youtube_url]', with: 'https://www.youtube.com/watch?v=8nxaZ69ElEc'

          click_button 'commit'
        end
        it '投稿成功' do
          expect(page).to have_content '動画投稿'
        end
      end

      context "一般ユーザーbがログインしているとき" do
        let(:login_user) { user_b }
        before do
          sign_in_as(login_user)

          visit new_video_path
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

    describe'video詳細ページ' do
      context '管理者aがログインしているとき' do
        let(:login_user) { user_a }
        before do
          sign_in_as(login_user)
          visit video_path(video_a)
        end

        it '編集リンクと削除リンクが表示される' do
          expect(page).to have_content 'この動画を削除する'
          expect(page).to have_content 'この動画を編集する'
        end
      end

      context ' 一般ユーザーbがログインしているとき' do
        let(:login_user) { user_b }
        before do
          sign_in_as(login_user)
          visit video_path(video_a)
        end

        it '編集リンクと削除リンクが表示されない' do
          expect(page).to have_no_content 'この動画を削除する'
          expect(page).to have_no_content 'この動画を編集する'
        end
      end

      context ' ログインしていないとき' do
        before do
          visit video_path(video_a)
        end

        it 'ログインページにリダイレクトにリダイレクトされる' do
          expect(page).to have_content 'ログインもしくはアカウント登録してください。'
        end
      end
    end

    describe'動画編集' do
      context '管理者aがログインしているとき' do
        let(:login_user) { user_a }

        before do
          sign_in_as(login_user)
          visit video_path(video_a)
          click_link 'この動画を編集する'
          fill_in 'video[title]', with: '編集済'

          click_button 'commit'
        end

        it '編集済に編集される' do
          expect(page).to have_content '編集済'
        end
      end

      context '一般ユーザーbがログインしているとき' do
        let(:login_user) { user_b }

        before do
          sign_in_as(login_user)
          visit edit_video_path(video_a)
        end

        it 'マイページにリダイレクトされる' do
          expect(page).to have_content '江口b'
        end
      end

      context '一般ユーザーbがログインしているとき' do
        before do
          visit edit_video_path(video_a)
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
    
          visit video_path(video_a)
          click_link 'この動画を削除する'
          page.driver.browser.switch_to.alert.accept 
        end
    
        it '投稿が削除される' do
          expect(page).to have_no_content '最初のビデオ'
        end 
      end
    end
  end
end
