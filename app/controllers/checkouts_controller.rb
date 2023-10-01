class CheckoutsController < ApplicationController
  #before_action :authenticate_user!
  before_action :set_reservation

  def show
    
    current_user.set_payment_processor :stripe
    current_user.payment_processor.customer

    @checkout_session = current_user
      .payment_processor
      .checkout(
        mode: 'payment',
        line_items: [
          {
            price_data: {
              currency: "usd",
              unit_amount: @reservation.flights.pluck(:fees).sum.to_int*100,
              product_data: {
                name: "Aerotows",
              },
            },
            quantity: 1,
          },
        ],
        success_url: checkout_success_url,
      )
  end

  def success
    @session = Stripe::Checkout::Session.retrieve(params[:session_id])
    @line_items = Stripe::Checkout::Session.list_line_items(params[:session_id])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reservation
      @reservation = Reservation.find(params[:id])
    end

end
