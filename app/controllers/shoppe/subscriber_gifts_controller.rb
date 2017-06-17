module Shoppe
  class SubscriberGiftsController < Shoppe::ApplicationController
    before_action :set_gift, only: [:show, :edit, :update, :destroy]

    before_filter { @active_nav = :subscriber_gifts }

    # GET /gifts
    def index
      @gifts = Shoppe::Gift.all
    end

    # GET /gifts/1
    def show
    end

    # GET /gifts/new
    def new
      @gift = Shoppe::Gift.new
    end

    # GET /gifts/1/edit
    def edit
    end

    # POST /gifts
    def create
      @gift = Shoppe::Gift.new(gift_params)

      if @gift.save
        redirect_to @gift, notice: 'Gift was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /gifts/1
    def update
      if @gift.update(gift_params)
        redirect_to @gift, notice: 'Gift was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /gifts/1
    def destroy
      @gift.destroy
      redirect_to gifts_url, notice: 'Gift was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_gift
        @gift = Shoppe::Gift.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def gift_params
        params[:gift]
      end
  end
end
