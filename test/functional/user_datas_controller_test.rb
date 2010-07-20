require 'test_helper'

class UserDatasControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:user_datas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user_data" do
    assert_difference('UserData.count') do
      post :create, :user_data => { }
    end

    assert_redirected_to user_data_path(assigns(:user_data))
  end

  test "should show user_data" do
    get :show, :id => user_datas(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => user_datas(:one).to_param
    assert_response :success
  end

  test "should update user_data" do
    put :update, :id => user_datas(:one).to_param, :user_data => { }
    assert_redirected_to user_data_path(assigns(:user_data))
  end

  test "should destroy user_data" do
    assert_difference('UserData.count', -1) do
      delete :destroy, :id => user_datas(:one).to_param
    end

    assert_redirected_to user_datas_path
  end
end
