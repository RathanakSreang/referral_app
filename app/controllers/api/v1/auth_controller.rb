class Api::V1::AuthController < ApiController
  swagger_controller :auth, "Auth API"

  swagger_api :signin do
    summary "User signing in"
    param :form, :email, :string, :required, "User email"
    param :form, :password, :string, :required, "User password"
    response :ok
    # response :unprocessable_entity
    # response :not_acceptable
  end
  def signin
  end

  swagger_api :signup do
    summary "User signup"
    param :form, :name, :string, :required, "User name"
    param :form, :email, :string, :required, "User email"
    param :form, :password, :string, :required, "User password"
    param :form, :referral_code, :string, :optional, "referral code"
    response :ok
    # response :unprocessable_entity
    # response :not_acceptable
  end
  def signup
  end

  swagger_api :signout do
    summary "User signing out from system"
  end
  def signout
  end
end
