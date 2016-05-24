class ApplicationController < ActionController::Base
  include Knock::Authenticable
  
  before_action :auth_user

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session


  def auth_user
    token = request.headers["token"]

    if token == nil
      render :json => { :message => "Must provide an auth token" }, :status => 401 and return false
    end

    begin
      payload = JWT.decode token, ENV["SECRET"], true, { :algorithm => 'HS256'}

      @user = User.find_by_email payload[0]["email"]

      if !@user
        render :json => { :message => "User does not exist. Please create and account or login as some one else" }, :status => 404
      end
    rescue JWT::ExpiredSignature
      render :json => { :message => "Your session has ended. Please login again" }, :status => 401
    end
  end
end
