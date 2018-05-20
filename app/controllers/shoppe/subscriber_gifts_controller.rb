module Shoppe
  class SubscriberGiftsController < Shoppe::ApplicationController
    before_action :set_subscriber_gift, only: [:show, :edit, :update, :destroy]

    before_filter { @active_nav = :subscriber_gifts }

    # GET /gifts
    def index
      @subscriber_gifts = Shoppe::SubscriberGift.all
    end

    # GET /gifts/1
    def show
    end

    # GET /gifts/new
    def new
      @subscriber_gift = Shoppe::SubscriberGift.new
      @products = Shoppe::Product.all
      @subscribers = Shoppe::Subscriber.unscoped.all
    end

    # GET /gifts/1/edit
    def edit
      @products = Shoppe::Product.all
      @subscribers = Shoppe::Subscriber.unscoped.all
    end

    # POST /gifts
    def create
      @subscriber_gift = Shoppe::SubscriberGift.new(gift_params)

      if @subscriber_gift.save
        # redirect_to @subscriber_gift, notice: 'Gift was successfully created.'
        redirect_to subscriber_gifts_url, notice: t('shoppe.gifts.successfully_created')
      else
        render :new
      end
    end

    # PATCH/PUT /gifts/1
    def update
      if @subscriber_gift.update(gift_params)
        redirect_to subscriber_gifts_url, notice: t('shoppe.gifts.successfully_updated')
      else
        render :edit
      end
    end

    # DELETE /gifts/1
    def destroy
      @subscriber_gift.destroy
      redirect_to subscriber_gifts_url, notice: t('shoppe.gifts.successfully_destroyed')
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_subscriber_gift
        @subscriber_gift = Shoppe::SubscriberGift.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def gift_params
        params.require(:subscriber_gift).permit(:subscriber_id, :product_id, :claimed)
      end
  end
end
