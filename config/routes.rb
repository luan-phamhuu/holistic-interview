Rails.application.routes.draw do
  root 'console#index'

  # post '/' => 'console#handle_command'

  get 'web_console' => 'console#web_console'
  mount LedisServer::API => '/'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
