require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  
  def setup
    @admin = users(:michael)
    @non_admin = users(:archer)
    @non_activated_user = users(:mike)
  end

  test "index including pagination and delete links" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination', count: 2
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      unless user.activated == false
        assert_select 'a[href=?]', user_path(user), text: user.name
        unless user == @admin
          assert_select 'a[href=?]', user_path(user), text: 'delete'
        end
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end

  test "index as non-admin" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end

  test "index only shows activated users" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: @non_activated_user.name, count: 0
    assert_select 'a', text: @non_admin.name, count: 1
  end

  test "user profile should not be visible unless activated" do
    get user_path(@non_activated_user)
    assert_redirected_to root_url
  end

end
