Rails.application.routes.draw do

  # Home
  root to: "home#top"
  post "/register", to: "home#register"
  get "/about", to: "home#about"
  get "/authority", to: "home#authority"
  get "/help", to: "home#help"
  get "/policy", to: "home#policy"
  get "/terms", to: "home#terms" # 利用規約
  get "/condition", to: "home#condition"


  # Bector

  # Microposts >> /bector/
  # Topics >> /bector/topics
  # 混合 >> /bector/posts




  get "/bector/top", to: "bector#top"
  get "/bector/custom/:level", to: "bector#custom"

  get "/bector/global", to: "bector#global"
  get "/bector/friends", to: "bector#friends"
  get "/bector/media", to: "bector#media"
  get "/bector/reactions/:id", to: "bector#reactions"

  post "/bector/search", to:"bector#search"

  get "/bector/users/:user_id", to:"bector#user"

  get "/bector/tags/:tag", to:"bector#tags"
  post "/bector/destroy", to:"bector#destroy"
  resources :bector, only: [:create, :destroy, :index]

  get "/bector/notifications"
  get "/bector/direct_messages"

  get "/bector/microposts/:id", to: "bector#show"
  post "/bector/microposts/:id", to: "bector#comment"

  # Users
  get "/users/edit", to: "users#edit"
  post "/users/update", to: "users#update"
  resources :users, only:  [:update, :destroy]
  get "/signup", to: "users#new"
  post "/signup", to: "users#create"
  get "/exit", to: "users#exit"


  post "/reports/", to: "reports#show"
  post "/reports/create", to:"reports#create"

  # Manages
  get '/manages', to: "manages#index"
  get '/manages/debug'
  post "/manages/fix"

  resources :manage_users
  post "/manage_users/:id", to: "manage_users#update"
  post "/manage_users/fix_model/:id", to: "manage_users#fix_model"

  resources :manage_bector
  post "/manage_bector/:id", to: "manage_bector#update"

  resources :manage_informations
  resources :manage_reports



  post "/reactions/:reactioned_type/:reactioned_id/create", to: "reactions#create"
  delete "/reactions/:reactioned_type/:reactioned_id/destroy", to: "reactions#destroy"


  # Sessions
  get "/login", to: "sessions#new"
  post '/login', to: 'sessions#create'
  get '/auth/twitter/callback', to: 'sessions#create'
  get "/login/:login_type", to: "sessions#new"
  post '/login/:login_type', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  delete "/logout/:service", to: "sessions#destroy"

  # Crafes! Routes ここから

  get     "/crafes",                              to: "crafes#index"                      # Topページ/コンテスト一覧
  get     "/crafes/about",                        to: "crafes#about"                      # Crafes!について
  get     "/crafes/schedule",                     to: "crafes#schedule"                   # 開催予定コンテスト
  get     "/crafes/finished",                     to: "crafes#finished"                   # 終了したコンテスト
  get     "/crafes/contests/new",                 to: "crafes#new_contest"                # 新規コンテスト作成
  post    "/crafes/contests",                     to: "crafes#create_contest"             # 新規コンテスト作成
  get     "/crafes/contests/guideline",           to: "crafes#contest_guideline"          # コンテスト作成のガイドライン
  get     "/crafes/draft_contests/:id",           to: "crafes#draft_contest_show"         # 非公開コンテストの詳細
  get     "/crafes/questions",                    to: "crafes#question_index"             # 公開問題一覧
  get     "/crafes/questions/new",                to: "crafes#new_question"               # 新規問題作成
  post    "/crafes/questions",                    to: "crafes#create_question"            # 新規問題作成
  get     "/crafes/questions/guideline",          to: "crafes#question_guideline"         # 問題作成のガイドライン
  get     "/crafes/question/:id",                 to: "crafes#show_question"              # 公開問題の詳細
  get     "/crafes/draft_questions/:id",          to: "crafes#draft_question_show"        # 非公開問題の詳細
  get     "/crafes/notifications",                to: "crafes#notifications"              # 通知
  get     "/crafes/contest/:id",                  to: "crafes#show_contest"               # 公開コンテストの詳細
  get     "/crafes/contest/:id/standings",        to: "crafes#standings"                  # 公開コンテストの順位表
  post    "/crafes/join/:id",                     to: "crafes#join_contest"               # コンテスト参加登録
  post    "/crafes/leave/:id",                    to: "crafes#leave_contest"              # コンテスト参加取り消し

  get     "/manage_contests",                     to: "manage_contests#index"
  post    "/manage_contests/create",              to: "manage_contests#create"
  post    "/manage_contests/destroy",             to: "manage_contests#destroy"
  get     "/manage_contests/draft"
  get     "/manage_contests/draft/:id",           to: "manage_contests#draft_show"
  post    "/manage_contests/draft/:id",           to: "manage_contests#draft_update"
  delete  "/manage_contests/draft/:id/destroy",   to: "manage_contests#draft_destroy"
  get     "/manage_contests/publish/:id",         to: "manage_contests#show"
  post    "/manage_contests/publish/:id",         to: "manage_contests#update"

  get     "/manage_questions",                    to: "manage_questions#index"
  get     "/manage_questions/draft"
  get     "/manage_questions/draft/:id",          to: "manage_questions#draft_show"
  post    "/manage_questions/draft/:id",          to: "manage_questions#draft_update"
  delete  "/manage_questions/draft/:id/destroy",  to: "manage_questions#draft_destroy"
  get     "/manage_questions/publish/:id",        to: "manage_questions#show"
  post    "/manage_questions/publish/:id",        to: "manage_questions#update"

  resources :manage_questions


  # Crafes! Routes ここまで

  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :relationships,       only: [:create, :destroy]

  resources :account_activations, only: [:edit]

  get "/:id", to: "users#show"
end
