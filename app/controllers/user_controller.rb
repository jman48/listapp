class UserController < ApplicationController

  def search
    search_string = params.require(:search).permit(:username)[:username]

    if search_string.length < 3
      render :json => {:message => "Search string is to short. Minimum of 3"}, :status => 400 and return false
    end

    users = User.where("username LIKE ?", search_string.downcase + "%").pluck(:username, :picture)

    users = users.map {|user|
      {:username => user[0], :picture => user[1]}
    }

    render :json => users.to_json, :status => 200
  end

end
