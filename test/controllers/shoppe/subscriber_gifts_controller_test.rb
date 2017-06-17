require 'test_helper'

module Shoppe
  class SubscriberGiftsControllerTest < ActionController::TestCase
    setup do
      @gift = shoppe_gifts(:one)
      @routes = Engine.routes
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:subscriber_gifts)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create gift" do
      assert_difference('Gift.count') do
        post :create, gift: {  }
      end

      assert_redirected_to gift_path(assigns(:gift))
    end

    test "should show gift" do
      get :show, id: @gift
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @gift
      assert_response :success
    end

    test "should update gift" do
      patch :update, id: @gift, gift: {  }
      assert_redirected_to gift_path(assigns(:gift))
    end

    test "should destroy gift" do
      assert_difference('Gift.count', -1) do
        delete :destroy, id: @gift
      end

      assert_redirected_to gifts_path
    end
  end
end
