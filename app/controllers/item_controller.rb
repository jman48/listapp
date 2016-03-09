class ItemController < ApplicationController
  before_action :get_list

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
end
