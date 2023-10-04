class CheckoutsController < ApplicationController
  #before_action :authenticate_user!
  

  def show
    @reservation = Reservation.find(params[:id])

    current_user.set_payment_processor :stripe
    current_user.payment_processor.customer

    @checkout_session = current_user
      .payment_processor
      .checkout(
        mode: 'payment',
        payment_method_configuration: 'pmc_1NxNOeHnDxnfrk7n8dp8f8yB',
        client_reference_id: @reservation.id,
        line_items: [
          {
            price_data: {
              currency: "usd",
              unit_amount: @reservation.flights.pluck(:fees).sum.to_int*100,
              product_data: {
                name: "Aerotow",
                description: "total fees for " + @reservation.reservation_date.strftime("%m/%d/%y"),

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
    @reservation = Reservation.find(@session.client_reference_id)

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    # not currently using this method
    def set_reservation
      @reservation = Reservation.find(params[:id])
    end

end
