require 'test_helper'

module Shoppe
  class SubscriberTransactionsControllerTest < ActionController::TestCase
    setup do
      @shoppe_subscriber_transaction = shoppe_subscriber_transactions(:one)
      @routes = Engine.routes
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:shoppe_subscriber_transactions)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create shoppe_subscriber_transaction" do
      assert_difference('Shoppe::SubscriberTransaction.count') do
        post :create, shoppe_subscriber_transaction: {  }
      end

      assert_redirected_to shoppe_subscriber_transaction_path(assigns(:shoppe_subscriber_transaction))
    end

    test "should show shoppe_subscriber_transaction" do
      get :show, id: @shoppe_subscriber_transaction
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @shoppe_subscriber_transaction
      assert_response :success
    end

    test "should update shoppe_subscriber_transaction" do
      patch :update, id: @shoppe_subscriber_transaction, shoppe_subscriber_transaction: {  }
      assert_redirected_to shoppe_subscriber_transaction_path(assigns(:shoppe_subscriber_transaction))
    end

    test "should destroy shoppe_subscriber_transaction" do
      assert_difference('Shoppe::SubscriberTransaction.count', -1) do
        delete :destroy, id: @shoppe_subscriber_transaction
      end

      assert_redirected_to shoppe_subscriber_transactions_path
    end
  end
end
