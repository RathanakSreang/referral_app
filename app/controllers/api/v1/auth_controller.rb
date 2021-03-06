class Api::V1::AuthController < ApiController
  swagger_controller :auth, "Auth API"
  before_action :authorized, only: [:signout]

  swagger_api :signin do
    summary "User signing in"
    param :form, :email, :string, :required, "User email"
    param :form, :password, :string, :required, "User password"
    response :ok
    response :unprocessable_entity
  end
  def signin
    user = User.find_by email: params[:email]
    if user && user.authenticate_password(params[:password])
      render_success({
        user: Api::V1::UserSerializer.new(user),
        access_token: user.generate_access_token!,
        refresh_token: "TODO"
      })
    else
      render_errors([{email_or_password: [ERROR_CODES[:invalid]]}])
    end
  end

  swagger_api :signup do
    summary "User signup"
    param :form, :name, :string, :required, "User name"
    param :form, :email, :string, :required, "User email"
    param :form, :password, :string, :required, "User password"
    param :form, :referral_code, :string, :optional, "referral code"
    response :ok
    response :bad_request
  end
  def signup
    user = User.new signup_params
    if user.save
      render_success({
        user: Api::V1::UserSerializer.new(user),
        access_token: user.generate_access_token!,
        refresh_token: "TODO"
      })
    else
      render_errors(user.errors.details, :bad_request)
    end
  end

  swagger_api :signout do
    summary "User signing out from system"
    param :query, :all_devices, :string, :optional, "Leave from all device: yes, no"
    response :ok
    response :unauthorized
  end
  def signout
    if params[:all_devices] == "yes"
      current_user.access_tokens.destroy_all
    else
      current_access_tokens.destroy
    end

    render_success({signout: true})
  end

  private

  def signup_params
    params.permit(:name, :email, :password, :referral_code)
  end
end
