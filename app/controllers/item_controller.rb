class ItemController < ApplicationController
  before_action :get_list
  before_action :get_item, only: [:delete, :show, :update]

  def create
    item = Item.new(item_params)
    @list.items.push(item)

    if @list.save
      render :json => item.to_json, :status => 201
    else
      render :json => {:message => @list.errors.messages.to_json}, :status => 400
    end
  end

  def list
    render :json => @list.items.to_json
  end

  def delete
    @item.destroy

    render :json => {:message => "Successfullu deleted item"}.to_json
  end

  def show
    render :json => @item
  end

  def update
    if @item.update(item_params)
      render :json => @item.to_json, :status => 200
    else
      render :json => {:message => @item.errors.messages}.to_json, :status => 400
    end
  end

  def order
    items = params.require(:items)

    items.each do |item_order|
      item = Item.find(item_order[:id])

      if !item.can_access @user
        render :json => {:message => "You are not allowed to access this item"}, :status => 403 and return false
      end

      item.update(order: item_order[:order])
    end

    render :json => {:message => "Items updated sucessfully"}.to_json, :status => 200
  end

  private

  def item_params
    params.require(:item).permit(:name)
  end

  def get_list
    if !List.exists? params[:list_id]
      render :json => {:message => "List not found"}, :status => 404
    else
      @list = List.includes(:users).find(params[:list_id])

      if !@list.can_access @user
        render :json => {:message => "You are not allowed to access this list"}, :status => 403 and return false
      end
    end
  end

  def get_item
    if !Item.exists? params[:id]
      render :json => {:message => "Item not found"}, :status => 404
    else
      @item = Item.find params[:id]

      if !@item.can_access @user
        render :json => {:message => "You do not have access to this item"}, :status => 403
      end
    end
  end
end
