class ProductsController < ApplicationController
  before_action :set_product, only: [:show]

  def index
    @products = Product.active.includes(:category, images_attachments: :blob)
    @categories = Category.joins(:products).where(products: { is_active: true }).distinct

    # Filter by category if specified
    if params[:category_id].present?
      @products = @products.where(category_id: params[:category_id])
      @selected_category = Category.find(params[:category_id])
    end

    # Search functionality
    if params[:search].present?
      @products = @products.where("name ILIKE ? OR description ILIKE ?",
                                 "%#{params[:search]}%", "%#{params[:search]}%")
    end

    # Filter options for feature 2.4 (filters)
    case params[:filter]
    when 'on_sale'
      @products = @products.on_sale
    when 'new'
      @products = @products.where('created_at > ?', 30.days.ago)
    when 'recently_updated'
      @products = @products.where('updated_at > ?', 7.days.ago)
    end

    # Add pagination - 12 products per page for customer view
    @products = @products.order(:name).page(params[:page]).per(12)
  end

  def show
    # Product detail page
    @related_products = Product.active
                              .where(category: @product.category)
                              .where.not(id: @product.id)
                              .includes(images_attachments: :blob)
                              .limit(4)
  end

  private

  def set_product
    @product = Product.active.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to products_path, alert: "Product not found."
  end
end