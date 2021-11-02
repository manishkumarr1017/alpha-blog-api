class UsersController < ApplicationController
    before_action :require_login, only: [:update, :show, :destory]
    before_action :set_user, only: [:show,:update,:destroy]
    before_action :require_same_user, only: [:update,:destroy]
    before_action :require_login, only: [:update, :show, :destory]
    wrap_parameters :user, include: [:username, :password, :password_confirmation, :email]
  
    def show
      begin
        render json: @user.to_json(:only => [:id, :username, :email])
      rescue => exception
        render json: {message: (exception.message)}
      end
    end
  
    def index
        render json: User.all.to_json(:only => [:id, :username, :email])
    end
  
    def update
      begin
        if @user.update(user_params)
            render json: {message: "user successfully updated"}, status: :accepted
        else
            render json: @user.errors.full_messages, status: :unprocessable_entity
        end
      rescue => exception
        if exception.message.include?("Couldn't find User")
            render json: {message: (exception.message)}
        else
            render json: {message: "Please provide username (minimum: 3, maximum: 25) or Valid email for creating an user in json form"}, status: :unprocessable_entity
        end
      end
    end
  
    def create
      begin
        @user = User.new(user_params)
        if @user.save
            render json: {message: "User successfully created"}, status: :created
        else
            render json: @user.errors.full_messages, status: :unprocessable_entity
        end
      rescue => exception
        render json: {message: "Please provide username (minimum: 3, maximum: 25) or Valid email for creating an user in json form"}, status: :unprocessable_entity
      end
    end
  
    def destroy
      begin
        if @user.destroy
            render json: {message: "User successfully deleted"}, status: :accepted
        end
      rescue => exception
        render json: {message: (exception.message)}
      end
    end
  
    private
    def user_params
      params.require(:user).permit(:username, :email, :password)
    end
  
    def set_user
      @user = User.find(params[:id])
    end
  
    def require_same_user
      if current_user_id != params[:id].to_i
        render json: { message: "You can only edit or delete your own account"},status: :unprocessable_entity
      end
    end
    
  end