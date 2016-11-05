require "test_helper"

feature "Login Users" do

  let(:submit) { "Log in" }
  let(:login_title) { "Log in" }
  let(:user) { users(:normal_user) }

  before do
    visit new_user_session_path

    page.must_have_content login_title
  end

  scenario "with valid information" do
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: 'passw0rd!'

    click_button submit
    page.must_have_content 'ダッシュボード'
  end

  scenario "with invalid information" do
    click_button submit
    page.must_have_content login_title
  end

end
