require 'rails_helper'

RSpec.describe AccessToken, type: :model do
  context "associations" do
    it { should belong_to(:user) }
  end

  context "scope" do
    describe "default scope" do
      let!(:token_no_expires) {FactoryBot.create :access_token}
      let!(:token_already_expired) {FactoryBot.create :access_token, expires_at: DateTime.current - 1.day}
      let!(:token_not_yet_expires) {FactoryBot.create :access_token, expires_at: DateTime.current + 1.day}

      it "should return only access token with expires_at NULL or not yet expires" do
        access_tokens = AccessToken.all
        expect(access_tokens.length).to eq 2
        expect(access_tokens.map(&:id)).not_to include(token_already_expired.id)
      end
    end
  end

  describe "verifies the token is set" do
    let(:access_token) {FactoryBot.build :access_token}
    it "should set token before create" do
      expect(access_token.token).to be_empty

      access_token.save
      expect(access_token.token).not_to be_empty
    end
  end
end
