class Api::V1::ReferralSerializer < BaseSerializer
  attributes :id, :referrer_credit, :user_credit, :reward_per_usage,
    :usage_count, :code, :referral_url, :created_at

  def referral_url
    Settings.frontend.base_referral_url + object.code
  end
end
