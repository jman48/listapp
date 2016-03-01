class ListController < ApplicationController

  def create
    list = List.new(list_params)

    if list.save
      render :json => list.to_json, :status => 201
    else
      render :json => {:message => list.errors.messages}.to_json, :status => 400
    end
  end

  def show
    if (List.exists? params[:id])
      list = List.find(params[:id])

      render :json => list.to_json, :status => 200
    else
      render :json => {:message => "List not found"}.to_json, :status => 404
    end
  end

  def delete
    if (List.exists? params[:id])
      List.find(params[:id]).destroy

      render :json => {:message => "Successfullu deleted list"}.to_json, :status => 200
    else
      render :json => {:message => "List not found"}.to_json, :status => 404
    end
  end

  def update
    if (List.exists? params[:id])
      list = List.find(params[:id])

      if (list.update(list_params))
        render :json => list.to_json, :status => 200
      else
        render :json => {:message => list.errors.messages}.to_json, :status => 400
      end
    else
      render :json => {:message => "List not found"}.to_json, :status => 404
    end
  end

  private

  def list_params
    params.require(:list).permit(:name)
  end
end
