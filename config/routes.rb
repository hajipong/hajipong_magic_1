Rails.application.routes.draw do
  root 'top#index'
  post 'convert', to: 'top#convert'
end
