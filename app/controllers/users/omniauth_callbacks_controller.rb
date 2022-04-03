class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def failure
    redirect_to root_path
  end

  def omniauth
    @user = OmniauthHandler.call(payload: request.env["omniauth.auth"])
    provider = request.env.dig("omniauth.auth", "provider")&.titleize

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication

      if is_navigational_format?
        set_flash_message(:notice, :success, kind: provider)
      end
    else
      session["devise.twitter_data"] = request.env["omniauth.auth"].except("extra")

      redirect_to(
        new_user_registration_path,
        alert: "Failed to login with #{provider}. Please proceed with normal registration or try again."
      )
    end
  end

  alias_method :facebook, :omniauth
  alias_method :twitter, :omniauth
end
