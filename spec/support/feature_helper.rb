module FeatureHelper
  def login_as(user)
    visit new_session_path

    fill_in 'session[email]', with: user.email
    fill_in 'session[password]', with: 'secret'

    click_button "Log in"
  end
end