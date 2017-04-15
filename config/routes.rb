Rails.application.routes.draw do
  root 'console#index'

  get 'web_console' => 'console#web_console'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
