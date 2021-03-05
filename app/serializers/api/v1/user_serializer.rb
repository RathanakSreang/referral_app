class Api::V1::UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :balance, :referral_code
end
