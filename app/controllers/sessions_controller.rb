class SessionsController < ApplicationController
  allow_unauthenticated_access

  def create
    user = User.authenticating(user_params)

    if user.is_a?(User) && user.errors.any?
      render json: { errors: user.errors.full_messages }, status: :unauthorized
    elsif user
      access_token = gen_access_token(user)

      cookies.signed[:refresh_token] = {
        value: gen_refresh_token(user),
        httponly: true,
        secure: Rails.env.production?,
        same_site: :strict
      }

      render json: { 
        access_token: access_token,
        message: "Logado com sucesso!",
        expires_at: 6.hours.from_now
      }
    else
      render plain: "Login e senha inválidos", status: :unauthorized
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
