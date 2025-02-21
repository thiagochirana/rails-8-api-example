Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  scope :backend do
    scope :v1 do
      scope :auth do
        post "/login", to: "sessions#create"
        put "/refresh", to: "sessions#refresh"
      end
      scope :register do
        post "/", to: "registrations#create"
        put "/update", to: "registrations#update"
        put "reset_password", to: "registrations#reset_password"
      end
    end
  end
end
