HerokuApp::Application.routes.draw do

  get "pairings/create"
  get "pairings/play"  
  match "pairings/chat1"
  get "pairings/quiz_results"
  get "pairings/chat2"
  get "pairings/money_decide"
  get "pairings/money_send"
  get "pairings/money_results"

  match "messages/create"
  get "messages/list"

  get "participants/enter_code"
  get "participants/create"
  get "participants/wait"

  get "qualtrics/empty"
  get "qualtrics/see"
  get "qualtrics/done"  
  get "qualtrics/amazon_turk_faux"

  resources :samples

  root :to => 'qualtrics#enter'

end
