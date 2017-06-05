Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  resources :slideshows do
    member do
      get 'draw_modal'
      get 'update_slideshow'
      get 'add_slide_to_slideshow'
    end

    collection do
      get 'search_slideshows'
      get 'draw_random'
      get 'draw_pose'
      get 'reload_pag'
      get 'reload_pag_user'
      get 'regen_rand'
      post 'create_show'
    end
  end

  resources :chatrooms do
    collection do 
      get 'get_user_sig'
      get 'chat_room_search'
    end
  end

  resources :taggings do
    collection do
      get 'tag_results'
      post 'create_tag'
    end

    member do
      delete 'delete_tag_from_slide'
    end
  end

  resources :users do
    collection do
      get 'my_account'
      get 'new_stuff'
      get 'edit_slideshow_modal'
      get 'my_sketches'
      get 'search'
    end
  end
  resources :slides do
    member do
      get 'inspect_modal'
      patch 'update_name'
    end

    collection do
      get 'reload_pag_account'
      get 'reload_pag'
      get 'slides_modal'
      get 'search_reload_pag'
      get 'search_reload_pag_row'
      get 'account_slides'
      get 'account_liked_slides'
      get 'general_slide_page'
    end
  end

  resources :slide_likes do 
    collection do
      delete 'unlike_slide'
      get 'check'
    end
  end

  resources :sketches do 
    collection do
      get 'get_sketch_image'
      get 'get_sketches_for_slide'
      get 'get_upload_form_for_slide'
    end
  end

  resources :sketch_likes do 
    collection do
      delete 'unlike_sketch'
      get 'check'
    end
  end



  devise_scope :user do
    get 'user_log_out_route/sign_out', :to => 'devise/sessions#destroy'
  end
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'users#welcome'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
