class Admin::ProductsController < Admin::ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = Product.includes(:category).order(:name)
    @products = @products.where("name ILIKE ?", "%#{params[:search]}%") if params[:search].present?
    @products = @products.where(category_id: params[:category_id]) if params[:category_id].present?
    @categories = Category.all
  end

  def show
    # Product details view
  end

  def new
    @product = Product.new
    @categories = Category.all
  end

  def create
    @product = Product.new(product_params)
    @categories = Category.all

    if @product.save
      flash[:notice] = "Product '#{@product.name}' was successfully created."
      redirect_to admin_product_path(@product)
    else
      flash.now[:alert] = "There were errors creating the product."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @categories = Category.all
  end

  def update
    @categories = Category.all

    if @product.update(product_params)
      flash[:notice] = "Product '#{@product.name}' was successfully updated."
      redirect_to admin_product_path(@product)
    else
      flash.now[:alert] = "There were errors updating the product."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    product_name = @product.name
    @product.destroy
    flash[:notice] = "Product '#{product_name}' was successfully deleted."
    redirect_to admin_products_path
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(
      :name, :description, :price, :sale_price, :stock_quantity,
      :sku, :weight, :is_active, :category_id, images: []
    )
  end
end