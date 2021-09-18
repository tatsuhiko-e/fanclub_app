require 'rails_helper'

RSpec.describe '', type: :system do
  let!(:user_a) { FactoryBot.create(:user, email: 'aaa@example.com', name:'江口aa')}
  let!(:user_b) { FactoryBot.create(:user, email: 'bbb@example.com', name:'江口b', admin: false)}
  let!(:user_c) { FactoryBot.create(:user, email: 'ccc@example.com', name:'江口c')}


  # describe '一覧表示機能' do
  #   context '管理者aがログインしている時' do
  #     let(:login_user) { user_a }

  #     before do
  #       sign_in_as(login_user)
  #       visit users_path
        
  #       binding.pry
        
  #     end
   
  #     it 'ファンクラブ一覧が表示される' do
  #       expect(page).to have_content '江口c'
  #     end
  #   end
  # end

  describe 'ユーザー新規作成機能' do
    context '管理者として新規作成する' do
      
    end
  end
end