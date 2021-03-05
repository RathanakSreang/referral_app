require "rails_helper"

RSpec.describe User, type: :model do
  context "associations" do
    it { should have_many(:access_tokens).dependent(:destroy) }
    it { should have_many(:rederals).class_name("Referral").dependent(:destroy) }
  end

  context "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(80) }
    it { should validate_presence_of(:email) }
    it { should validate_length_of(:email).is_at_most(255) }
    it { should validate_uniqueness_of(:email) }
    it { should validate_presence_of(:password).on(:create) }
    it { should validate_length_of(:password).is_at_least(6).on(:create) }

    context "on update" do
      it { should validate_length_of(:password).is_at_least(6).allow_blank.on(:update) }
    end

    context "email" do
      context "invalid format" do
        it "should invalid user" do
          user = FactoryBot.build :user
          expect(user.valid?).to eq true

          invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
            foo@bar_baz.com foo@bar+baz.com]
          invalid_addresses.each do |invalid_address|
            user.email = invalid_address
            expect(user.valid?).to eq false
          end
        end
      end

      context "valid format" do
        it "should valid user" do
          user = FactoryBot.build :user
          expect(user.valid?).to eq true

          valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
            first.last@foo.jp alice+bob@baz.cn]
          valid_addresses.each do |valid_address|
            user.email = valid_address
            expect(user.valid?).to eq true
          end
        end
      end
    end

    context "validate_referral_code" do
      context "referral_code not exist" do
        let(:user) {FactoryBot.build :user, referral_code: ""}
        it "should valid" do
          expect(user.valid?).to eq true
        end
      end

      context "referral_code exist" do
        it "should valid if referral found" do
          user = FactoryBot.build :user, referral_code: "unknown_code"
          expect(user.valid?).to eq false
        end

        it "should invalid if referral not found" do
          referral = FactoryBot.create :referral
          user = FactoryBot.build :user, referral_code: referral.code
          expect(user.valid?).to eq true
        end
      end
    end
  end

  describe "claim credit after create" do
    let(:user) {FactoryBot.build :user, balance: 0}
    it "should not increase balance if no referral_code" do
      user.save
      expect(user.balance).to eq 0
    end

    context "referral_code exist" do
      let(:referrer) {FactoryBot.create :user, balance: 0}
      let(:referral) {FactoryBot.create :referral, referrer: referrer}
      let(:user) {FactoryBot.build :user, balance: 0, referral_code: referral.code}

      it "should add credit to user balance" do
        user.save
        expect(user.balance).to eq 10
      end

      it "should call referral increase_usage_count!" do
        expect_any_instance_of(Referral).to receive(:increase_usage_count!)
        user.save
      end
    end
  end
end
