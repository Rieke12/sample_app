require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end
  
  test "layout links as guest" do
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path  
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", signup_path
  end

  test "layout links as logged-in user" do
    log_in_as(@user)
    assert_redirected_to user_path(@user)
    follow_redirect!
    assert_select "a[href=?]", users_path
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", edit_user_path(@user)
    assert_select "a[href=?]", user_path(@user)
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path  
  end

test "page titles should be correct" do
    get root_path
    assert_select "title", full_title("")

    get contact_path
    assert_select "title", full_title("Contact")

    get about_path
    assert_select "title", full_title("About")

    get help_path
    assert_select "title", full_title("Help")

    get signup_path
    assert_select "title", full_title("Sign up")
    
    get login_path
    assert_select "title", full_title("Log in")

    log_in_as(@user)
    assert_redirected_to user_path(@user)
    follow_redirect!

    get users_path
    assert_select "title", full_title("All users")

    get edit_user_path(@user)
    assert_select "title", full_title("Edit user")
  end  
end
