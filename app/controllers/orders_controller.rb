class OrdersController < ApplicationController

  before_filter :require_login

  def show
    @order = Order.find(params[:id])
  end

  def index
    @orders = current_user.orders
  end

  def create
    # charge = perform_stripe_charge
    # order  = create_order(charge)

    @order = process_razorpayment(payment_params)

    if @order.valid?
      empty_cart!
      redirect_to @order, notice: 'Your Order has been placed.'
    else
      redirect_to cart_path, error: @order.errors.full_messages.first
    end

  rescue Stripe::CardError => e
    redirect_to cart_path, error: e.message
  end

  private


  def process_razorpayment(params)
    # product = Product.find(params[:product_id])
    razorpay_pmnt_obj = fetch_payment(params[:payment_id])
    status = fetch_payment(params[:payment_id]).status
    if status == "authorized"
      razorpay_pmnt_obj.capture({amount: cart_total})
      razorpay_pmnt_obj = fetch_payment(params[:payment_id])
      # params.merge!({status: razorpay_pmnt_obj.status, price: product.price})
      create_order(params[:payment_id])
    else
      raise StandardError, "UNable to capture payment"
    end
  end

  def fetch_payment(raz_payment_id)
    Razorpay::Payment.fetch(raz_payment_id)
  end

  def payment_params
    # p = params.permit(:payment_id, :user_id, :product_id, :price, :razorpay_payment_id)
    p = params.permit(:payment_id, :price, :razorpay_payment_id, :user_id, :address_id)
    p.merge!({payment_id: p.delete(:razorpay_payment_id) || p[:payment_id]})
    p
  end

  def filter_params
    params.permit(:status, :page)
  end

  def process_refund(payment_id)
    fetch_payment(payment_id).refund
    record = Order.find_by_payment_id(payment_id)
    record.update_attributes(status: fetch_payment(payment_id).status)
    return record
  end

  def filter(params)
    scope = params[:status] ? Order.send(params[:status]) : Order.authorized
    return scope
  end

  def empty_cart!
    # empty hash means no products in cart :)
    update_cart({})
  end

  def perform_stripe_charge
    Stripe::Charge.create(
      source:      params[:stripeToken],
      amount:      cart_total, # in cents
      description: "Jungle Order",
      currency:    'cad'
    )
  end

  def create_order(stripe_charge_id)
    order = Order.new(
      email: current_user.email,
      total_cents: cart_total,
      stripe_charge_id: stripe_charge_id, # returned by stripe
      user_id: params[:user_id],
      address_id: params[:address_id]
    )
    cart.each do |product_id, details|
      if product = Product.find_by(id: product_id)
        quantity = details['quantity'].to_i
        order.line_items.new(
          product: product,
          quantity: quantity,
          item_price: product.price,
          total_price: product.price * quantity
        )
      end
    end
    order.save!
    order
  end

  # returns total in cents not dollars (stripe uses cents as well)
  def cart_total
    total = 0
    cart.each do |product_id, details|
      if p = Product.find_by(id: product_id)
        total += p.price_cents * details['quantity'].to_i
      end
    end
    total
  end

end
