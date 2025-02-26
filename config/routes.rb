Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  scope :backend do
    scope :v1 do
      scope :auth do
        post "/login", to: "sessions#create", as: :login
        put "/refresh", to: "sessions#refresh", as: :refresh
      end
      scope :register do
        post "/", to: "registrations#create", as: :register
        put "/update", to: "registrations#update", as: :register_update
        put "reset_password", to: "registrations#reset_password", as: :register_reset_pass
      end
    end
  end
end
