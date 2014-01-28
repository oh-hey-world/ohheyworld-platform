Web::Application.routes.draw do

  resources :user_location_asset

  resources :user_location_tagged_users


  namespace :admin do
    resources :users do
      member do
        get :impersonate
      end
    end
    resources :communities
  end


  match 'mission', :to => 'pages#mission'
  match 'about', :to => 'pages#about'
  match 'team', :to => 'pages#team'
  match 'privacy', :to => 'pages#privacy'
  match 'tos', :to => 'pages#tos'
  match 'faq', :to => 'pages#faq'
  match 'feedback', :to => 'pages#feedback'
  match 'jobs', :to => 'pages#jobs'
  match 'api', :to => 'pages#api'
  match 'maintenance', :to => 'pages#maintenance'
  match 'happy_customers', :to => 'pages#happy_customers'
  match 'community_guidelines', :to => 'pages#community_guidelines'
  match 'checking_in', :to => 'pages#checking_in'
  match 'welcome_kits', :to => 'pages#welcome_kits'
  match 'location_aware_group_management', :to => 'pages#location_aware_group_management'
  match 'conferences', :to => 'pages#conferences'
  match 'welcome_kits_b', :to => 'pages#welcome_kits_b'
  match 'special_thanks', :to => 'pages#special_thanks'
  match 'community_pages', :to => 'pages#community_pages'
  match 'support_us', :to => 'pages#support_us'
  match 'community_pages_community_builders', :to => 'pages#community_pages_community_builders'
  match 'communities_beta', :to => 'pages#communities_beta'
  match 'travatar', :to => 'pages#travatar'
  match 'colophon', :to => 'pages#colophon'

  get "twilio/process_sms"

  match 'twilio/process_sms' => 'twilio#process_sms'

  namespace :admin do resources :beta_access_requests end

  namespace :admin do resources :registration_codes end

  namespace :admin do resources :dashboard end

  namespace :admin do resources :countries end

  namespace :admin do resources :languages end

  namespace :admin do resources :beta_users end

  get "omniauth_callbacks_controller/facebook"

  devise_for :users, controllers: { registrations: "registrations", sessions: "sessions", passwords: "passwords", confirmations: "confirmations" } do
    get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
    put 'users' => 'devise/registrations#update', :as => 'user_registration'
  end

  devise_scope :user do
    match "/users/auth/facebook/setup" => "users/omniauth_callbacks#setup"
    match "/users/auth/facebook" => "users/omniauth_callbacks#facebook"
    match "/users/auth/facebook/callback" => "users/omniauth_callbacks#facebook"
    match "/users/auth/twitter" => "users/omniauth_callbacks#twitter"
    match "/users/auth/twitter/callback" => "users/omniauth_callbacks#twitter"
  end

  # match '/users/tags/kiva' => redirect('/kiva')
  # match '/kiva' => 'communities#show'

  match 'users/tags(/:perma_list)' => 'users#tags', :as => 'users_tags'

  namespace :api do
    devise_for :users

    resources :users, :except=>[:destroy] do
      member do
        get 'badge'
      end
      collection do
        get 'notification_contact_details'
      end
    end

    resources :locations, :except=>[:destroy] do
      collection do
        get 'search'
      end
    end

    resources :user_locations do
      member do
        get 'user_friends_not_ohw_user'
        get 'users_at_location'
        get 'user_friends_ohw_user'
      end
    end

    resources :user_friends do
    end

    resources :user_provider_friends do
    end

    resources :user_assets do
    end

    resources :languages do
    end

    resources :user_languages do
      collection do
        put 'mass_update'
      end
    end

    resources :notification_contact_details do
    end
  end

  resources "user_provider_friends" do
    collection do
      get 'follow'
    end
  end

  resources "user_friends" do
    collection do
      get 'network'
      get 'dashboard'
      get 'travel_feed', to: 'user_friends#dashboard'
      get 'grouped_friends'
      put 'update_tag'
      get 'following/:user_id', :action => 'following', :as => 'following'
      get 'followers/:user_id', :action => 'followers', :as => 'followers'
      put :send_invitation_email
    end
  end

  resources :provider_friends do
    collection do
      get 'network'
      get 'grouped_friends'
    end
  end

  resources :locations do
    collection do
      get 'provider_friends'
    end
  end

  resources :user_searches do
    collection do
      get :site_search
      get :search_users
    end
    member do
      get :more_users_with_tag
      get :more_friends
    end
  end

  resources :beta_users

  resources :beta_access_requests

  resources :notification_contact_details

  resources :user_contacts

  resources :user_city_tips do
    member do
      put :like_city_tip
    end
  end

  resources :user_cities do
    member do
    end
    collection do
      #get ':city_id(/:user_id)', action: 'city_tips', as: 'city_tips'
    end
  end

  match 'city_tips/:city_id(/:user_id)' => 'user_cities', action: 'city_tips', as: 'city_tips', via: [:get]

  resources :preferences

  match 'users/registration_code' => 'users#registration_code', via: [:get]
  match 'users/awaiting_confirmation' => 'users#awaiting_confirmation', via: [:get]
  match 'users/enter_registration_code' => 'users#enter_registration_code', via: [:post]

  resource :users do
    collection do
      get :more_people_with_tags
    end
  end

  resources :users, :path => '' do
    member do
      get :settings
      get :privacy
      get :profile
      get :impersonate
      put :update_tags
      put :update_profile
      post :import_facebook_friends
      get :import_facebook_friends_finished
      get :new_notification_contact_details
      get :reset_completed_first_checkin
      get :auth_callback
      get :network
      get :tag_notifications
      put :update_tag_notifications
      put :checkin
      put :update_friend_tag
      put :update_friend_profile_tag
      get 'lists(/:tag)', action: 'lists', as: 'lists'
      get :more_locations
    end
    collection do
      get 'travelblog(/:slug)', action: 'travelblog', as: 'travelblog'
    end
  end

  #community resources

  resources :communities do
    member do
      get :detail
    end
    resources :community_profiles, as: "members", path: "/member" do
      member do
        get :join
        post :create
      end
      collection do
        get :invite
      end
    end
  end

  resources :users, :path => '', :only => [] do
    resources :user_locations, :path => '', :except => [:index] do
      get :notifications
      put :send_notifications
      put :update_privacy
      member do
        put :like_checkin
        put :like_comment
        post :add_comment
        post :add_note
        get :friends
      end
    end
  end

  resources :user_locations do
    collection do
      post :save_user_client_location
    end
    member do
      get 'country(/:country_id)(state/:state_id)', :action => 'show', :as => 'country_state'
      put :update_user
      put :update_photos
      get :more_friends
      put :like_checkin
      put :like_comment
      post :ask_for_advice
      post :add_comment
      post :add_note
      get :friends
    end
  end


  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'users#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
