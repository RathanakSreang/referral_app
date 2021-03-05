FactoryBot.define do
  factory :referral do
    referrer_credit 10
    user_credit 10
    usage_count 0
    reward_per_usage 5
    referrer factory: :user
  end
end



