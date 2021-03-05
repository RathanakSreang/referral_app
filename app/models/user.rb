class User < ApplicationRecord
  has_many :access_tokens, dependent: :destroy
  has_many :rederals, class_name: "Referral",
                      foreign_key: "referrer_id",
                      dependent: :destroy

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :name, presence: true, length: { maximum: 80 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
  validates :password, presence: true, length: {minimum: 6}, on: :create
  validates :password, length: {minimum: 6}, allow_blank: true, on: :update
  validate  :validate_referral_code, on: :create

  before_save :downcase_email
  after_create :claim_credit!

  has_secure_password

  def generate_access_token!
    access_token = access_tokens.create! expires_at: DateTime.current + Settings.auth.expires_in.days
    access_token.token
  end

  private

  def validate_referral_code
    if referral_code.present?
      unless Referral.where(code: referral_code).exists?
        errors.add(:referral_code, "not_exist")
      end
    end
  end

  def downcase_email
    self.email.downcase!
  end

  def claim_credit!
    return unless referral_code.present?

    referral = Referral.find_by(code: referral_code)
    if referral
      self.balance += referral.user_credit
      self.save
      referral.increase_usage_count!
    end
  end
end
