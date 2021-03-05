require "rails_helper"

RSpec.describe Api::V1::ReferralsController, type: :controller do
  describe "GET #index" do
    context "authorized user" do
      let!(:user) {FactoryBot.create :user}
      let!(:access_token) {FactoryBot.create :access_token, user: user}
      context "user has referrals" do
        let(:referral_fields) {
          ["code", "created_at", "id", "referral_url", "referrer_credit",
            "reward_per_usage", "usage_count", "user_credit"]
        }
        before :each do
          3.times do
            FactoryBot.create :referral, referrer: user
          end
          authentication_token access_token.token
          get :index, params: {}, format: :json
        end
        it "returns empty referrals list" do
          expect(response).to be_successful
          expect(json_body["data"].keys).to match_array(["referrals"])
          expect(json_body["data"]["referrals"].length).to eq(3)
          expect(json_body["data"]["referrals"][0].keys).to match_array(referral_fields)
        end
      end
      context "user has no referrals" do
        before :each do
          authentication_token access_token.token
          get :index, params: {}, format: :json
        end
        it "returns empty referrals list" do
          expect(response).to be_successful
          expect(json_body["data"].keys).to match_array(["referrals"])
          expect(json_body["data"]["referrals"]).to match_array([])
        end
      end
    end

    context "unauthorized user" do
      before :each do
        get :index, params: {}, format: :json
      end
      it "returns fail" do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "GET #index" do
    context "authorized user" do
      let!(:user) {FactoryBot.create :user}
      let!(:access_token) {FactoryBot.create :access_token, user: user}
      let(:referral_fields) {
          ["code", "created_at", "id", "referral_url", "referrer_credit",
            "reward_per_usage", "usage_count", "user_credit"]
        }
      before :each do
        authentication_token access_token.token
        post :create, params: {}, format: :json
      end

      it "returns referral info" do
        expect(response).to be_successful
        expect(json_body["data"].keys).to match_array(["referral"])
        expect(json_body["data"]["referral"].keys).to match_array(referral_fields)
        expect(json_body["data"]["referral"]["code"]).not_to be_empty
      end
    end

    context "unauthorized user" do
      before :each do
        post :create, params: {}, format: :json
      end
      it "returns fail" do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
