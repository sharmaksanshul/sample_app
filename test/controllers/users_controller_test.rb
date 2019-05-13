require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user       = users(:anshul)
     @other_user = users(:amit)
     @another_user = users(:michael)
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

   test "should redirect edit when logged in as wrong user" do
    log_in_as(@user)
    get edit_user_path(@other_user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@user)
    patch user_path(@other_user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end

   test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@user)
    assert_not @user.admin?
    patch user_path(@user), params: {
                                    user: { password:              "anshul",
                                            password_confirmation: "anshul",
                                            admin: true } }
    assert_not @user.admin?
  end

   test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete user_path(@another_user)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@user)
    assert_no_difference 'User.count' do
      delete user_path(@other_user)
    end
    assert_redirected_to root_url
  end

   test "should redirect following when not logged in" do
    get following_user_path(@user)
    assert_redirected_to login_url
  end

  test "should redirect followers when not logged in" do
    get followers_user_path(@user)
    assert_redirected_to login_url
  end

end
