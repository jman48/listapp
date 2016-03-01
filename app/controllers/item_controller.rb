class ItemController < ApplicationController

  def create
    if (List.exists? params[:list_id])
      list = List.find params[:list_id]
      item = Item.new(item_params)
      list.items.push(item)

      if list.save
        render :json => {:message => "Item saved successfully"}
      else
        render :json => {:message => list.errors.messages.to_json}, :status => 400
      end
    else
      render :json => {:message => "List not found"}, :status => 400
    end
  end

  private

  def item_params
    params.require(:item).permit(:name)
  end
end
