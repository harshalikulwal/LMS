Rails.application.routes.draw do
  get 'holidays/index'
  get 'leaves/index'
  get 'welcome/index'
  post '/leaves/new' => 'leaves#create'
  #patch '/leaves/:id' => 'leaves#update'
  #match '/leaves/:id' => 'leaves#update', :via => [:get, :post]
  #patch '/leaves/:id/edit' => 'leaves#edit'
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :holidays
  resources :leaves do
    member do
      put 'approve_leave'
    end
    collection do
      get 'leave_history'
      get 'leave_to_approve'
    end
  end
  authenticated :user do
    root "leaves#index", as: "authenticated_root"
  end
  root "welcome#index"
end
