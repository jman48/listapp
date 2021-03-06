class ListController < ApplicationController
  before_action :get_list, only: [:show, :delete, :update, :add_users, :get_users, :remove_user]

  def create
    list = List.new(list_params)

    list.users.push @user

    if list.save
      render :json => list.to_json, :status => 201
    else
      render :json => {:message => list.errors.messages}.to_json, :status => 400
    end
  end

  def show
    render :json => @list
  end

  def all
    lists = List.joins(:users).where(:users => {:id => @user.id})

    render :json => lists.to_json
  end

  def delete
    @list.destroy

    render :json => {:message => "Successfullu deleted list"}.to_json
  end

  def update
    if @list.update(list_params)
      render :json => @list.to_json, :status => 200
    else
      render :json => {:message => @list.errors.messages}.to_json, :status => 400
    end
  end

  def order
    lists = params.require(:lists)

    lists.each do |list_order|
      list = List.find(list_order[:id])

      if !list.can_access @user
        render :json => {:message => "You are not allowed to access this list"}, :status => 403 and return false
      end

      list.update(order: list_order[:order])
    end

    render :json => {:message => "Lists updated sucessfully"}.to_json, :status => 200
  end

  def add_users
    usernames = params.require(:users)

    users = User.where(username: usernames)

    users.each { |user|
      if !@list.users.include?(user)
        @list.users.push(user)
      end
    }

    if @list.save
      render :json => {:message => "Users added to list"}
    else
      render :json => {:message => @list.errors.messages}.to_json, :status => 400
    end
  end

  def get_users
    users = @list.users.map { |user|
      {:username => user.username, :picture => user.picture, :user_id => user.id}
    }

    render :json => users.to_json
  end

  def remove_user
    if !User.exists? params[:user_id]
      render :json => {:message => "User not found"}, :status => 404 and return false
    end

    user = User.find(params[:user_id])

    if @list.users.length > 1
      @list.users.delete(user)
    else
      render :json => {:message => "Can not delete the only user on this list"}, :status => 400 and return false
    end

    if @list.save
      render :json => {:message => "User removed from list"}
    else
      render :json => {:message => @list.errors.messages}, :status => 400
    end

  end

  private

  def list_params
    params.require(:list).permit(:name, :username)
  end

  def get_list
    if List.exists? params[:id]
      @list = List.includes(:users).find(params[:id])

      if !@list.can_access @user
        render :json => {:message => "You are not allowed to access this list"}, :status => 403 and return false
      end
    else
      render :json => {:message => "List not found"}.to_json, :status => 404 and return false
    end
  end
end
