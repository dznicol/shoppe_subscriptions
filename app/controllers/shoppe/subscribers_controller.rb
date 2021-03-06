module Shoppe
  class SubscribersController < Shoppe::ApplicationController
    before_action :set_subscriber, only: [:show, :edit, :update, :destroy]
    before_action :set_subscription_plan, only: [:index, :create, :new]

    before_filter { @active_nav = :subscribers }

    # GET /subscribers
    def index
      @subscribers = @subscription_plan.present? ? @subscription_plan.subscribers : Shoppe::Subscriber.all
      @cancelled_subscribers = @subscription_plan.present? ? @subscription_plan.cancelled_subscribers : Shoppe::Subscriber.cancelled
    end

    # GET /subscribers/1
    def show
    end

    # GET /subscribers/new
    def new
      @subscriber = Subscriber.new
    end

    # GET /subscribers/1/edit
    def edit
    end

    # POST /subscribers
    def create
      @subscriber = Subscriber.new(subscriber_params)

      if @subscriber.save
        redirect_to @subscriber, notice: t('shoppe.subscribers.create_notice')
      else
        render :new
      end
    end

    # PATCH/PUT /subscribers/1
    def update
      if @subscriber.update(subscriber_params)
        redirect_to [@subscription_plan, :subscribers], notice: t('shoppe.subscribers.update_notice')
      else
        render :edit
      end
    end

    # DELETE /subscribers/1
    def destroy
      @subscriber.update_attribute(:cancelled_at, DateTime.now)
      redirect_to [@subscription_plan, :subscribers], notice: t('shoppe.subscribers.cancelled_notice')
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_subscriber
      @subscriber = Subscriber.unscoped.find(params[:id])

      # Also set the Stripe API Key for API actions on this subscriber
      @subscriber.stripe_api_key = ENV[session[:stripe_account]]
    end

    def set_subscription_plan
      @subscription_plan = SubscriptionPlan.find(params[:subscription_plan_id]) if params[:subscription_plan_id].present?
    end

    # Only allow a trusted parameter "white list" through.
    def subscriber_params
      params.require(:subscriber).permit(:subscriber_plan_id, :customer_id, :recipient_name, :recipient_email,
                                         :recipient_phone, :balance, :stripe_id)
    end
  end
end
