class BulkDiscountsController < ApplicationController
  before_action :find_bd_and_merchant, only: [:show, :edit, :update, :destroy]
  before_action :find_merchant, only: [:new, :create, :index]

  def index 
    @bulk_discounts = @merchant.bulk_discounts
  end

  def show
  end

  def new
  end

  def create
    discount = BulkDiscount.new(discount: params[:discount], 
                        threshold: params[:threshold], 
                        merchant: @merchant)
    if discount.save 
      redirect_to merchant_bulk_discounts_path(@merchant)
    else
      redirect_to new_merchant_bulk_discount_path(@merchant)
      flash.notice = "Ya gotta do better than that..."
    end
  end

  def edit 
  end

  def update
    if @bd.update(bulk_discount_params)
      flash.notice = "Successfully Updated Bulk Discount"
      redirect_to merchant_bulk_discount_path(@merchant, @bd)
    else 
      flash.notice = "Ya gotta do better than that..."
      redirect to edit_merchant_bulk_discount_path(@merchant, @bd)
    end
  end

  def destroy
    @bd.destroy
    redirect_to merchant_bulk_discounts_path(@merchant)
  end

  private

  def bulk_discount_params
    params.require(:bulk_discount).permit(:discount, :threshold)
  end

  def find_bd_and_merchant
    @bd = BulkDiscount.find(params[:id])
    @merchant = Merchant.find(params[:merchant_id])
  end

  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end
end