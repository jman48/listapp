class ListController < ApplicationController
  before_action :get_list, only: [:show, :delete, :update]

  def create
    list = List.new(list_params)

    if list.save
      render :json => list.to_json, :status => 201
    else
      render :json => {:message => list.errors.messages}.to_json, :status => 400
    end
  end

  def show
    render :json => @list
  end

  def delete
    @list.destroy

    render :json => {:message => "Successfullu deleted list"}.to_json
  end

  def update
    if @list.update(list_params)
      render :json => list.to_json, :status => 200
    else
      render :json => {:message => list.errors.messages}.to_json, :status => 400
    end
  end

  private

  def list_params
    params.require(:list).permit(:name)
  end

  def get_list
    if List.exists? params[:id]
      @list = List.find params[:id]
    else
      render :json => {:message => "List not found"}.to_json, :status => 404
    end
  end
end
