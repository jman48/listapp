class ItemController < ApplicationController
  before_action :get_list
  before_action :get_item, only: [:delete, :item]

  def create
    item = Item.new(item_params)
    @list.items.push(item)

    if @list.save
      render :json => {:message => "Item saved successfully"}
    else
      render :json => {:message => @list.errors.messages.to_json}, :status => 400
    end
  end

  def show
    render :json => @list.items.to_json
  end

  def delete
    @item.destroy

    render :json => {:message => "Successfullu deleted item"}.to_json
  end

  def item
    render :json => @item
  end

  private

  def item_params
    puts params.to_json
    params.require(:item).permit(:name)
  end

  def get_list
    if !List.exists? params[:list_id]
      render :json => {:message => "List not found"}, :status => 404
    else
      @list = List.find(params[:list_id])
    end
  end

  def get_item
    if !Item.exists? params[:id]
      render :json => {:message => "Item not found"}, :status => 404
    else
      @item = Item.find params[:id]
    end
  end
end
