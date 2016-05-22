Rails.application.routes.draw do

  scope '/lists' do
    post '/' => 'list#create'
    get '/' => 'list#all'
    get '/:id' => 'list#show'
    delete '/:id' => 'list#delete'
    put '/:id' => 'list#update'
    post '/:id/users' => 'list#add_user'
    put '/order' => 'list#order'

    scope '/:list_id/items' do
      post '/' => 'item#create'
      get '/' => 'item#list'
      delete '/:id' => 'item#delete'
      get '/:id' => 'item#show'
      put '/:id' => 'item#update'
      put '/order' => 'item#order'
    end
  end

  scope '/users' do
    post '/' => 'user#sign_up'
    post '/login' => 'user#login'
    get '/' => 'user#show'
  end
end
