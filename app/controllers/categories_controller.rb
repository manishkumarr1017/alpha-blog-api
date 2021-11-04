class CategoriesController < ApplicationController
  def index
    render json: Category.all.to_json(:only => [:id, :name])
  end

  def show
    begin
      set_category
      render json: @category.to_json(:only => [:id, :name])
    rescue => exception
      render json: {message: (exception.message)}
    end
  end
  

  def create
    begin
      @category = Category.new(category_params)
      if @category.save
        render json: {message: "Category successfully created"}, status: :created
      else
        render json: @category.errors.full_messages, status: :unprocessable_entity
      end

    rescue => exception
      render json: {message: "Please provide the name of the category"}, status: :unprocessable_entity
      
    end
  end

  def update
    begin
      set_category
      if @category.update(category_params)
        render json: {message: "Category successfully updated"}, status: :accepted
      else
        render json: @category.errors.full_messages, status: :unprocessable_entity
      end
    rescue => exception
      if exception.message.include?("Couldn't find Category")
        render json: {message: (exception.message)}
      else
        render json: {message: "Please provide a category name for updating a specific category in json form"}, status: :unprocessable_entity
      end
    end
  end

  def destroy
    begin
      set_category
      if @category.destroy
        render json: {message: "Category successfully deleted"}, status: :accepted
      end
    rescue => exception
      render json: {message: (exception.message)}
    end
  end
  

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name)
  end 
  
end