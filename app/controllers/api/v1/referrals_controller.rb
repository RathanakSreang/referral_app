class Api::V1::ReferralsController < ApiController
  before_action :load_referral, only: [:show, :update, :destroy]
  swagger_controller :occupation, "Referral"

  swagger_api :index do
    summary "Referral list"
  end
  def index
    render json: {
      referrals: []
    }
  end

  swagger_api :show do
    summary "Returns referral detail"
    param :path, :id, :integer, :required,  "ID"
  end
  def show
    render json: {
      referral: {}
    }
  end

  swagger_api :create do
    summary "create referral"
  end
  def create
    # occupation = Occupation.new occupation_params
    # if occupation.save
    #   json_response({occupation: occupation.as_json(only: [:id, :title])})
    # else
    #   render_error({errors: occupation.errors})
    # end
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
  def load_referral
    # @occupation = Occupation.find params[:id]
  end
end
