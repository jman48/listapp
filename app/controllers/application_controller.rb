class ApplicationController < ActionController::Base
  include Knock::Authenticable
  
  before_action :authenticate, :show_user

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  def show_user
    @user = current_user
  end

  def log_warn msg
    logger.warn '[' + @user.user_id.to_s + '] - ' + msg
  end
end
