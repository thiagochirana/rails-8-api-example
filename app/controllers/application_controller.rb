class ApplicationController < ActionController::API
  include Authentication
  include Env
  include ActionController::Cookies
end
