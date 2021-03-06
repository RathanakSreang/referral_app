class Api::V1::UserSerializer < BaseSerializer
  attributes :id, :email, :name, :balance, :referral_code
end
