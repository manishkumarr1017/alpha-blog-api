class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :update, :destroy]
  before_action :require_login, only: [:create, :update, :destory]
  before_action :require_same_user, only: [:update, :destroy]

  def index
    if params[:user_id]
      @articles = User.find(params[:user_id]).articles
    elsif params[:categories_id]
      @articles = Category.find(params[:category_id]).articles
    else
      @articles = Article.all
    end
    render json: @articles.to_json(:only => [:id, :title, :description])
  end

  def show
    begin
      set_article
      render json: @article.to_json(:only => [:id, :title, :description])
    rescue => exception
      render json: {message: (exception.message)}
    end
  end
  

  def create
    begin
      @article = Article.new(article_params)
      @article.user_id = current_user_id
      if @article.save
        render json: {message: "Article successfully created"}, status: :created
      else
        render json: @article.errors.full_messages, status: :unprocessable_entity
      end

    rescue => exception
      render json: {message: "Please provide title (minimum: 6, maximum: 100) or description (minimum: 10, maximum: 300) for creating an article in json form"}, status: :unprocessable_entity
      
    end
  end

  def update
    begin
      set_article
      if @article.update(article_params)
        render json: {message: "Article successfully updated"}, status: :accepted
      else
        render json: @article.errors.full_messages, status: :unprocessable_entity
      end
    rescue => exception
      if exception.message.include?("Couldn't find Article")
        render json: {message: (exception.message)}
      else
        render json: {message: "Please provide title (minimum: 6, maximum: 100) or description (minimum: 10, maximum: 300) for updating an article in json form"}, status: :unprocessable_entity
      end
    end
  end

  def destroy
    begin
      set_article
      if @article.destroy
        render json: {message: "Article successfully deleted"}, status: :accepted
      end
    rescue => exception
      render json: {message: (exception.message)}
    end
  end
  

  private

  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :description)
  end

  def require_same_user
    if current_user_id != params[:id].to_i
      render json: { message: "You can only edit or delete your own account"},status: :unprocessable_entity
    end
  end
  
end