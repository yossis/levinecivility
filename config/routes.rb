HerokuApp::Application.routes.draw do

  get "qualtrics/empty"
  get "qualtrics/see"
  get "qualtrics/done"

  root :to => 'qualtrics#see'

end
