class Referral < ApplicationRecord
  belongs_to :referrer, class_name: "User"

  validates :referrer_credit, presence: true,
                              numericality: { greater_than_or_equal_to: 0 }
  validates :user_credit, presence: true,
                          numericality: { greater_than_or_equal_to: 0 }
  validates :reward_per_usage, presence: true,
                               numericality: { only_integer: true, greater_than: 0 }

  before_create :set_referral_code

  def increase_usage_count!
    self.usage_count += 1
    if self.usage_count % self.reward_per_usage == 0
      User.update_counters(self.referrer.id, balance: self.referrer_credit)
    end

    self.save
  end

  private
  def set_referral_code
    self.code = generate_code
  end

  def generate_code
    loop do
      random_code = SecureRandom.alphanumeric(10)
      break random_code unless Referral.where(code: random_code).exists?
    end
  end
end
