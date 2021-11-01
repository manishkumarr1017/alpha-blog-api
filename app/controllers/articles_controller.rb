class ArticlesController < ApplicationController

  def index
    render json: Article.all.to_json(:only => [:id, :title, :description])
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
  
end