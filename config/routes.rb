Rails.application.routes.draw do
  constraints ApiConstraints do
    resources :contacts
  end
end
