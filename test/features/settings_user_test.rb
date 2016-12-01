require "test_helper"

feature "Settings User" do

  background do
    @user = create(:user)
    login_as(@user, :scope => :user)
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

  feature "Update" do

    scenario "with valid information" do
      visit settings_users_path
      page.must_have_selector '.pageheader h2', text: "ユーザー設定"

      page.must_have_content @user.email

      click_link "編集"

      page.must_have_selector "h4.panel-title", text: "ユーザー編集"

      fill_in "user[name]", with: "#{@user.name}_edit"

      click_button "更新"

      page.must_have_selector ".alert-success", text: "ユーザーを更新しました"

      page.must_have_content "#{@user.name}_edit"
    end

    scenario "with invalid information" do
      visit settings_users_path
      page.must_have_selector '.pageheader h2', text: "ユーザー設定"

      page.must_have_content @user.email

      click_link "編集"

      page.must_have_selector "h4.panel-title", text: "ユーザー編集"

      fill_in "user[name]", with: ""
      fill_in "user[email]", with: ""

      click_button "更新"

      page.must_have_selector "h4.panel-title", text: "ユーザー編集"
      page.must_have_selector ".alert-danger", text: "ユーザーの更新に失敗しました"
    end
  end

  feature "Delete" do

    background do
      @delete_user = create(:user)
    end

    scenario "successful", js: true do
      visit settings_users_path
      page.must_have_selector '.pageheader h2', text: "ユーザー設定"

      page.must_have_content @delete_user.email

      page.accept_confirm "ユーザーを削除しますか" do
        click_link "削除", href: settings_user_path(@delete_user)
      end

      page.must_have_selector ".alert-success", text: "ユーザーを削除しました"
    end

  end

end
