class UserController < ApplicationController

  def sign_up
    user = user_params

    salt = BCrypt::Engine.generate_salt
    user[:password] = BCrypt::Engine.hash_secret(user[:password], salt)

    new_user = User.new(user)

    if new_user.save
      render :json => {:message => "User created successfully"}, :status => 201
    else
      render :json => {:message => new_user.errors.messages}, :status => 400
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :password, :auth_token)
  end
end
