class ListController < ApplicationController

  def create
    list = List.new(list_params)
    
    if list.save
      render :json => list.to_json, :status => 201
    else
      render :json => list.errors.messages.to_json, :status => 400
    end
  end

  private

  def list_params
    params.require(:list).permit(:name)
  end
end
