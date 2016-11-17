require "test_helper"

feature "User Session Test" do

  feature "Login" do
    let(:submit) { "Log in" }
    let(:login_title) { "Log in" }
    let(:user) { create(:user) }

    before do
      user
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

  feature "Logout" do
    let(:user) { create(:user) }

    before do
      login_as(user, :scope => :user)
    end

    scenario "successful", js: true do
      visit root_path
      page.must_have_content 'ダッシュボード'

      all(".headermenu .btn-group")[1].click

      click_link 'サインアウト'
    end

  end


end
