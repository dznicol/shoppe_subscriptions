module Shoppe
  class SubscriberTransactionsController < ApplicationController

    before_filter { @active_nav = :subscriber_transactions }
    before_action :set_subscriber_transaction, only: [:show, :edit, :update, :destroy]

    # GET /subscriber_transactions
    def index
      @subscriber_transactions = Shoppe::SubscriberTransaction.all.order(id: :desc).page(params[:page])
    end

    # GET /subscriber_transactions/1
    def show
    end

    # GET /subscriber_transactions/new
    def new
      @subscriber_transaction = Shoppe::SubscriberTransaction.new
      @subscribers = Shoppe::Subscriber.unscoped.all
    end

    # GET /subscriber_transactions/1/edit
    def edit
      @subscribers = Shoppe::Subscriber.unscoped.all
    end

    # POST /subscriber_transactions
    def create
      @subscriber_transaction = Shoppe::SubscriberTransaction.new(subscriber_transaction_params)

      if @subscriber_transaction.save
        redirect_to subscriber_transactions_url, notice: 'Subscriber transaction was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /subscriber_transactions/1
    def update
      if @subscriber_transaction.update(subscriber_transaction_params)
        redirect_to edit_subscriber_transaction_url(@subscriber_transaction), notice: 'Subscriber transaction was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /subscriber_transactions/1
    def destroy
      @subscriber_transaction.destroy
      redirect_to subscriber_transactions_url, notice: 'Subscriber transaction was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_subscriber_transaction
        @subscriber_transaction = Shoppe::SubscriberTransaction.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def subscriber_transaction_params
        params.require(:subscriber_transaction).permit(:subscriber_id, :subtotal, :total, :discount_code, :transaction_type)
      end
  end
end
