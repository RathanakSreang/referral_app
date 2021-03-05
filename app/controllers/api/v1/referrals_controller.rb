class Api::V1::ReferralsController < ApiController
  swagger_controller :referral, "Referral"
  before_action :authorized

  swagger_api :index do
    summary "Referral list"
    response :ok
    response :unauthorized
  end
  def index
    referrals = current_user.referrals
    render_success({
      referrals: ActiveModel::Serializer::CollectionSerializer.new(referrals, serializer: Api::V1::ReferralSerializer)
    })
  end

  swagger_api :create do
    summary "create a referral"
    response :ok
    response :unauthorized
    response :bad_request
  end
  def create
    referral = current_user.build_referral
    if referral.save
      render_success({
        referral: Api::V1::ReferralSerializer.new(referral)
      })
    else
      render_errors(referral.errors.details, :bad_request)
    end
  end
end
