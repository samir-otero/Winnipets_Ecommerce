class Admin::CategoriesController < Admin::ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  def index
    @categories = Category.includes(:products).order(:name)

    # Apply search filter
    if params[:search].present?
      @categories = @categories.where("name ILIKE ?", "%#{params[:search]}%")
    end

    # Add pagination - 10 categories per page
    @categories = @categories.page(params[:page]).per(10)
  end

  def show
    @products = @category.products.includes(:category, images_attachments: :blob).order(:name)

    # Add pagination for products within category - 12 per page
    @products = @products.page(params[:page]).per(12)
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      flash[:notice] = "Category '#{@category.name}' was successfully created."
      redirect_to admin_category_path(@category)
    else
      flash.now[:alert] = "There were errors creating the category."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # Edit form
  end

  def update
    if @category.update(category_params)
      flash[:notice] = "Category '#{@category.name}' was successfully updated."
      redirect_to admin_category_path(@category)
    else
      flash.now[:alert] = "There were errors updating the category."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    category_name = @category.name

    if @category.products.any?
      flash[:alert] = "Cannot delete category '#{category_name}' because it has associated products."
      redirect_to admin_categories_path
    else
      @category.destroy
      flash[:notice] = "Category '#{category_name}' was successfully deleted."
      redirect_to admin_categories_path
    end
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :description)
  end
end