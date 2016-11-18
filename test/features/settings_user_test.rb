require "test_helper"

feature "Settings User" do

  background do
    user = create(:user)
    login_as(user, :scope => :user)
  end

  feature "Create" do

    let(:new_user_attrs) { attributes_for(:user) }

    scenario "with valid information" do
      visit settings_users_path
      page.must_have_selector '.pageheader h2', text: "ユーザー設定"

      click_link "新規登録"

      page.must_have_selector "h4.panel-title", text: "新規登録"

      fill_in "user[name]", with: new_user_attrs[:name]
      fill_in "user[email]", with: new_user_attrs[:email]
      fill_in "user[password]", with: new_user_attrs[:password]
      fill_in "user[password_confirmation]", with: new_user_attrs[:password]

      click_button "登録"

      page.must_have_selector ".alert-success", text: "ユーザーを登録しました"
    end
  end

end
