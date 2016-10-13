Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  mount Resque::Server.new, :at => "/resque"

  devise_for :users

  root 'dashboards#index'

  namespace :settings do
    resources :users, except: :show
    resources :channels, except: :show
    resources :system_infos, only: [:index]
    get 'logs/web', controller: :logs, action: :web
    get 'logs/recorder', controller: :logs, action: :recorder
    get 'logs/worker', controller: :logs, action: :worker
  end

  resources :server_infos, only: [] do
    collection do
      get 'current_time'
    end
  end

  resources :programs, only: [:index, :show] do
    member do
      post :reserve
    end
  end

  resources :reserve_rules, except: :show do
    member do
      post :switch_status
    end
    collection do
      post :reservation_update
    end
  end

  resources :reservations, only: [:index, :show, :destroy] do
    collection do
      get 'status/:status', action: :index, as: :status
    end
  end

  resources :videos, except: [:new, :create]
  match 'players/:id', controller: :players, action: :show, via: :get, as: :show_player
  match 'players/:id/play', controller: :players, action: :play, via: :get, as: :play_player
end
