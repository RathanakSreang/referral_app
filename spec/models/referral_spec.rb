require "rails_helper"

RSpec.describe Referral, type: :model do
  context "associations" do
    it { should belong_to(:referrer).class_name("User") }
  end

  context "validations" do
    it { should validate_presence_of(:referrer_credit) }
    it { should validate_numericality_of(:referrer_credit).is_greater_than_or_equal_to(0) }
    it { should validate_presence_of(:user_credit) }
    it { should validate_numericality_of(:user_credit).is_greater_than_or_equal_to(0) }
    it { should validate_presence_of(:reward_per_usage) }
    it { should validate_numericality_of(:reward_per_usage).only_integer.is_greater_than(0) }
  end

  describe ".increase_usage_count!" do
    let(:referral) {FactoryBot.create :referral}

    it "should increase it usage_count" do
      expect(referral.usage_count).to eq 0

      referral.increase_usage_count!
      expect(referral.usage_count).to eq 1
    end

    context "usage_count reach reward_per_usage" do
      let(:referrer) {FactoryBot.create :user, balance: 0}
      let(:referral) {FactoryBot.create :referral, referrer: referrer, usage_count: 4, reward_per_usage: 5}
      it "should add credit to referrer" do
        expect(referrer.balance).to eq 0

        referral.increase_usage_count!
        expect(referrer.reload.balance).to eq 10
      end

      it "should add credit for every cycle" do
        referral.increase_usage_count!
        expect(referrer.reload.balance).to eq 10

        referral.update_attributes usage_count: 9
        referral.increase_usage_count!
        expect(referrer.reload.balance).to eq 20
      end

      it "should only a credit is add to referrer balance" do
        referral.increase_usage_count!
        expect(referrer.reload.balance).to eq 10

        referral.update_attributes usage_count: 24
        referral.increase_usage_count!
        expect(referrer.reload.balance).to eq 20
      end
    end
  end
end
