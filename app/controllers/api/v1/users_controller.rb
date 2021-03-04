class Api::V1::UsersController < ApiController
  before_action :load_user, only: [:show, :update, :destroy]
  swagger_controller :occupation, "User"

  swagger_api :show do
    summary "Returns user detail"
    param :path, :id, :integer, :required,  "ID"
  end
  def show
    render json: {
      user: {}
    }
  end

  swagger_api :destroy do
    summary 'Delete referral'
    param :path, :id, :integer, :required,  "ID"
  end
  def destroy
    # @occupation.destroy
    # json_response({id: params[:id]})
  end

  private
  def load_user
    # @occupation = Occupation.find params[:id]
  end
end
