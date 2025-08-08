class Admin::CategoriesController < Admin::ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  def index
    @categories = Category.all.order(:name)
    @categories = @categories.where("name ILIKE ?", "%#{params[:search]}%") if params[:search].present?
  end

  def show
    @products = @category.products.includes(:category).order(:name)
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