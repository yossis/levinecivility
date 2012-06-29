HerokuApp::Application.routes.draw do


  get "admin/export"

  get 'participants/create' => 'participants#create'
  get 'pairings/create' => 'pairings#create'

  resources :messages, :only => [:create, :list]
  #resources :pairings, :only => [:create]
  #resources :participants, :only => [:create]


  match 'collaboration/chat/:which_chat' => 'collaboration#chat', :which_chat => /1|2/
  match 'collaboration/end_chat/:which_chat' => 'collaboration#end_chat', :which_chat => /1|2/
  match 'collaboration/:action' => 'collaboration#:action'

  match 'qualtrics/:action' => 'qualtrics#:action'

  match 'admin' => 'admin#export'
  match 'admin/:action' => 'admin#:action'

  root :to => 'qualtrics#start'

end
