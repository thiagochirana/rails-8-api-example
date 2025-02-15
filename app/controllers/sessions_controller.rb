class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }

  def new
  end

  def create
    if user = User.authenticate_by(params.permit(:email_address, :password))
      start_new_session_for user
      redirect_to after_authentication_url
    else
      redirect_to new_session_path, alert: "Try another email address or password."
    end
  end

  def destroy
    terminate_session
    redirect_to new_session_path
  end
end

class SessionsController < ApplicationController
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }
  allow_unauthenticated_access

  def create
    user = User.authenticate_by(email: user_params[:login], password: user_params[:password])

    if user.is_a?(User) && !user.errors.any?
      render json: { access_token: gen_access_token(user), refresh_token: gen_refresh_token(user), message: "Logado com sucesso!" }
    else
      render json: { errors: [ "Login e senha inválidos" ] }, status: :unauthorized
    end
  end

  def refresh
    generate_new_access_token_by_refresh
  end

  private

  def user_params
    params.permit(:login, :password)
  end
end
