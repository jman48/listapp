class UserController < ApplicationController
  before_action :auth_user, :except=> [:sign_up, :login]

  def sign_up
    new_user = User.new(user_params)

    if new_user.save
      render :json => {:message => "User created successfully"}, :status => 201
    else
      render :json => {:message => new_user.errors.messages}, :status => 400
    end
  end

  def login
    user = User.find_by_username(user_params[:username])

    if user == nil
      render :json => {:message => "Username or password is incorrect"}, :status => 400 and return false
    end

    if user.authenticate user_params[:password]

      expiry = Time.now + 7.days

      payload = {:username => user.username, :exp => expiry.to_i}

      token = JWT.encode payload, ENV["SECRET"], 'HS256'

      response.headers["token"] = token

      render :json => {:token => token}
    else
      render :json => {:message => "Username or password is incorrect"}, :status => 400
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :password, :auth_token)
  end
end
