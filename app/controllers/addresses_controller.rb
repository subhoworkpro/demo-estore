class AddressesController < ApplicationController

  before_filter :require_login

  def new
    @address = Address.new
  end

  def create

    @address = Address.new(address_params)
    @address.user = current_user
    if @address.save
      flash[:success] = "New Address Saved!"
      redirect_to [:checkout]
    else
      redirect_to :back
    end


    # @product = Product.find(params[:product_id])
    # @review = @product.reviews.create(review_params)
    # @review.user = current_user

    # if @review.save
    #   flash[:success] = "Review added!"
    #   redirect_to :back
    # else
    #   flash[:danger] = "Something blew up. Sorry about that."
    #   redirect_to :back
    # end

  end

  def destroy
    # @review = Review.find params[:id]
    # @review.destroy
    # flash[:danger] = "Review deleted!"
    # redirect_to :back
  end

  private

  def address_params
    params.require(:address).permit(:locality, :street, :city, :state, :postal_code, :country)
  end

end
