class AccessToken < ApplicationRecord
  belongs_to :user

  default_scope {where("expires_at IS NULL or expires_at > '#{Time.now}'")}

  before_create :set_access_token


  private

  def set_access_token
    self.token = generate_token
  end

  def generate_token
    loop do
      random_token = SecureRandom.base64(15)
      break random_token unless AccessToken.where(token: random_token).exists?
    end
  end
end
