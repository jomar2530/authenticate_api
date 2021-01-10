# Gems I used (Active model Serializer and Bcrypt)
# I added an action in user model to authenticate the password

class UsersController < ApplicationController
  def create
    user = User.create(user_params)
    
    return render_error(user.errors.full_messages) unless user.valid?
    
    user.save

    render json: UserSerializer.new(user), status: :ok
  end

  def auth
    user = User.find_by_username(user_params[:username]).try(:check_password, user_params[:password])
    
    return render_error unless user

    render json: UserSerializer.new(user), status: :ok
  end

  private

  def render_error(message = ['Wrong username or password'])
    render json: { errors: message }, status: :unauthorized
  end

  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation)
  end
end
