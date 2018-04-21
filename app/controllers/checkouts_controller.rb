class CheckoutsController < ApplicationController

  before_filter :require_login

  def add_item
    product_id = params[:product_id].to_s

    item = cart[product_id] || { "quantity" => 0 }
    item["quantity"] += 1
    cart[product_id] = item
    update_cart cart

    redirect_to :back
  end

  def remove_item
    product_id = params[:product_id].to_s

    item = cart[product_id] || { "quantity" => 1 }
    item["quantity"] -= 1
    cart[product_id] = item
    cart.delete(product_id) if item["quantity"] < 1
    update_cart cart

    redirect_to :back
  end

  def remove_all
    update_cart({})

    redirect_to :back
  end

  def index
    @addresses = current_user.addresses
  end

  def show
    @addresses = current_user.addresses

    @cart_total = 0
    cart.each do |product_id, details|
      product = Product.find_by(id: product_id)
      quantity = details['quantity'].to_i
      item_total = product.price * quantity
      @cart_total += item_total
    end
  end

end
