class ListController < ApplicationController
  before_action :get_list, only: [:show, :delete, :update, :add_user]

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

  def add_user
    username = params.require(:user).permit(:username)[:username]
    new_user = User.find_by_username(username)

    if new_user == nil
      render :json => { :message => "Can not add user" }, :status => 400
    end

    @list.users.push(new_user)

    if @list.save
      render :json => { :message => "User added to list" }
    else
      render :json => {:message => @list.errors.messages}.to_json, :status => 400
    end
  end

  def order
    lists = params.require(:lists)

    lists.each do |list|
      List.find(list[:id]).update(order: list[:order])
    end

    render :json => {:message => "Lists updated sucessfully"}.to_json, :status => 200
  end

  private

  def list_params
    params.require(:list).permit(:name, :username)
  end

  def get_list
    if List.exists? params[:id]
      @list = List.includes(:users).find(params[:id])

      if !@list.users.include? @user
        render :json => {:message => "You are not allowed to access this list"}, :status => 403 and return false
      end
    else
      render :json => {:message => "List not found"}.to_json, :status => 404 and return false
    end
  end
end
