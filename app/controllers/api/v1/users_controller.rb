class Api::V1::UsersController < ApiController
  swagger_controller :users, "User"
  before_action :authorized

  swagger_api :my_profile do
    summary "Returns current user detail"
    response :ok
    response :unauthorized
  end
  def my_profile
    render_success({
      user: Api::V1::UserSerializer.new(current_user)
    })
  end
end
