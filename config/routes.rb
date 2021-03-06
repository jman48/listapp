Rails.application.routes.draw do

  scope '/lists' do
    post '/' => 'list#create'
    get '/' => 'list#all'
    get '/:id' => 'list#show'
    delete '/:id' => 'list#delete'
    put '/order' => 'list#order'
    put '/:id' => 'list#update'
    post '/:id/users' => 'list#add_users'
    get '/:id/users' => 'list#get_users'
    delete '/:id/users/:user_id' => 'list#remove_user'

    scope '/:list_id/items' do
      post '/' => 'item#create'
      get '/' => 'item#list'
      delete '/:id' => 'item#delete'
      get '/:id' => 'item#show'
      put '/order' => 'item#order'
      put '/:id' => 'item#update'
    end
  end

  scope '/users' do
    post '/search' => 'user#search'
    get '/' => 'user#get_logged_in'
  end
end
