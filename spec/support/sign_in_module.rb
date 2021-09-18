module SignInModule
    def sign_in_as(user)
      visit user_session_path
      fill_in 'user[email]', with: login_user.email
      fill_in 'user[password]', with: login_user.password
      click_button 'Log in'
    end
  end
  