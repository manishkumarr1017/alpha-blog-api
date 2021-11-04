class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]
  before_action :require_login, only: [:update, :destory]
  before_action :require_same_user, only: [:update, :destroy]

  def index
    render json: User.all.to_json(:only => [:id, :username, :email], :methods => [:get_avatar])
  end

  def show
    begin
      set_user
      render json: @user.to_json(:only => [:id, :username, :email], :methods => [:get_avatar])
    rescue => exception
      render json: {message: (exception.message)}
    end
  end
  

  def create
    begin
      @user = User.new(user_params)
      if @user.save
        render json: {jwt: "JWT token gets here"}, status: :created
      else
        render json: @user.errors.full_messages, status: :unprocessable_entity
      end

    rescue => exception
      render json: {message: "Please provide necessary details for signing up the user"}, status: :unprocessable_entity
      
    end
  end

  def update
    begin
      set_user
      if @user.update(user_params)
        render json: {message: "User profile successfully updated"}, status: :accepted
      else
        render json: @user.errors.full_messages, status: :unprocessable_entity
      end
    rescue => exception
      if exception.message.include?("Couldn't find User")
        render json: {message: (exception.message)}
      else
        render json: {message: "Please provide necessary details for updating the user"}, status: :unprocessable_entity
      end
    end
  end

  def destroy
    begin
      set_user
      if @user.destroy
        render json: {message: "User profile successfully got deleted"}, status: :accepted
      end
    rescue => exception
      render json: {message: (exception.message)}
    end
  end
  
  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.permit(:username, :email, :avatar, :password)
  end 

  def require_same_user
    if current_user_id != params[:id].to_i
      render json: { message: "You can only edit or delete your own account"},status: :unprocessable_entity
    end
  end
  
end