require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "signup posts to valid url test" do
    get signup_path
    assert_select 'form[action="/signup"]'
  end

  test "invalid signup information" do
    get signup_path
    #compares User.count before and after executing the block
    assert_no_difference 'User.count' do
      post users_path, params: { 
        user: {
          name: "",
          email: "user@invalid",
          password: "foo",
          password_confirmation: "bar"
        }
      }
    end
    assert_template 'users/new'
    assert_select "div.alert-danger", "The form contains 4 errors."
    assert_select "div#error_explanation"
    assert_select "div.field_with_errors"
  end

  test "valid signup information with account activation" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: {
        user: {
          name: "Firstname",
          email: "fn.ln@prov.test",
          password: "foobar",
          password_confirmation: "foobar"
        }
      }
    end
    #exactly one email was delivered
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    #try to log in without activation
    log_in_as(user)
    assert_not is_logged_in?
    #try to log in with invalid token
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not is_logged_in?
    #try to log in with wrong email, valid token
    get edit_account_activation_path(user.activation_token, email: "worng")
    assert_not is_logged_in?
    #valid activation toekn and email
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end
end
