class CommentsController < ApplicationController
  before_action :set_comment, only: [:update, :destroy]
  before_action :require_login, only: [:create, :update, :destory]
  before_action :require_same_user, only: [:update, :destroy]

  def index
    if params[:article_id]
      @comments = Article.find(params[:article_id]).comments
    end
    render json: @comments.to_json(:only => [:id, :content])
  end

  def show
    begin
      set_article
      render json: @article.comments.find(params[:id]).to_json(:only => [:id, :content])
    rescue => exception
      render json: {message: (exception.message)}
    end
  end
  

  def create
    begin
      if params[:article_id]
        set_article
        byebug
        @comment = Comment.new(comment_params)
        @comment.user_id = current_user_id
        if @article.comments << @comment
          render json: {message: "Comment successfully added"}, status: :created
        else
          render json: @comment.errors.full_messages, status: :unprocessable_entity
        end
      end
    rescue => exception
      render json: {message: "Please login and provide comment in json form"}, status: :unprocessable_entity
      
    end
  end

  def update
    begin
      set_article
      if @comment.update(comment_params)
        render json: {message: "Comment successfully updated"}, status: :accepted
      else
        render json: @article.errors.full_messages, status: :unprocessable_entity
      end
    rescue => exception
      if exception.message.include?("Couldn't find comment")
        render json: {message: (exception.message)}
      else
        render json: {message: "Please login and provide comment in json form"}, status: :unprocessable_entity
      end
    end
  end

  def destroy
    begin
      set_comment
      if @comment.destroy
        render json: {message: "Comment successfully deleted"}, status: :accepted
      end
    rescue => exception
      render json: {message: (exception.message)}
    end
  end
  

  private

  def set_article
    @article = Article.find(params[:article_id])
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end

  def require_same_user
    if current_user_id != Comment.find(params[:id]).user_id
      render json: { message: "You can only edit or delete your own comments"},status: :unprocessable_entity
    end
  end
  
end