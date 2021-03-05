require "rails_helper"

RSpec.describe Api::V1::AuthController, type: :controller do
  describe "POST #signin" do
    let!(:user) {FactoryBot.create :user}
    let(:params) {{}}
    before :each do
      post :signin, params: params, format: :json
    end

    context "signin success" do
      let(:params) {{email: user.email, password: "1234567890"}}

      it "returns user info" do
        expect(response).to be_successful
        expect(json_body["data"]["user"]["id"]).to eq(user.id)
        expect(json_body["data"]["user"].keys).to match_array(["id", "name", "balance", "email", "referral_code"])
      end

      it "returns user access token" do
        expect(response).to be_successful
        expect(json_body["data"]["access_token"]).not_to be_empty
      end
    end

    context "signin fail" do
      let(:params) {{email: user.email, password: "incorrect"}}
      it "returns unprocessable_entity" do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_body["errors"].length).to eq 1
        expect(json_body["errors"][0]["email_or_password"]).to include(ERROR_CODES[:invalid])
      end
    end
  end

  describe "POST #signup" do
    let(:params) {{}}
    before :each do
      post :signup, params: params, format: :json
    end
    context "signup success" do
      let(:params) {{name: "Awesome", email: "awesome@test.com", password: "1234567890"}}
      it "returns user info and access token" do
        expect(response).to be_successful
        expect(json_body["data"].keys).to match_array(["user", "access_token"])
        expect(json_body["data"]["user"].keys).to match_array(["id", "name", "balance", "email", "referral_code"])
        expect(json_body["data"]["access_token"]).not_to be_empty
        expect(json_body["data"]["user"]["email"]).to eq("awesome@test.com")
      end

      context "without referral code" do
        let(:params) {{name: "Awesome", email: "awesome@test.com", password: "1234567890"}}
        it "returns user with balance 0" do
          expect(json_body["data"]["user"]["balance"]).to eq(0)
        end
      end

      context "with valid referral code" do
        let(:referrer) {FactoryBot.create :user, balance: 0}
        let(:referral) {FactoryBot.create :referral, referrer: referrer}
        let(:params) {{name: "Awesome", email: "awesome@test.com", password: "1234567890", referral_code: referral.code}}

        it "returns user with credited balance" do
          expect(json_body["data"]["user"]["balance"]).to eq(referral.user_credit)
        end
      end
    end

    context "signup fail" do
      context "missing require field" do
        let(:params) {{name: "Awesome"}}

        it "returns bad_request with errors fields" do
          expect(response).to have_http_status(:bad_request)
          expect(json_body["errors"].keys).to match_array(["email", "password"])
        end
      end

      context "invalid referral_code" do
        let(:params) {{name: "Awesome", email: "awesome@test.com", password: "1234567890", referral_code: "unknown"}}
        it "returns bad_request with errors fields" do
          expect(response).to have_http_status(:bad_request)
          expect(json_body["errors"].keys).to match_array(["referral_code"])
        end
      end
    end
  end

  describe "DELETE #signout" do
    context "user logging" do
      let!(:user) {FactoryBot.create :user}
      let!(:access_token) {FactoryBot.create :access_token, user: user}
      before :each do
        2.times do
          FactoryBot.create :access_token, user: user
        end
        authentication_token access_token.token
      end
      context "signout only one" do
        before :each do
          delete :signout, params: {}, format: :json
        end
        it "returns success and remove only one access_token" do
          expect(response).to be_successful
          expect(user.access_tokens.count).to eq 2
        end
      end

      context "signout all" do
        before :each do
          delete :signout, params: {all_devices: "yes"}, format: :json
        end
        it "returns success and remove all user's access_tokens" do
          expect(response).to be_successful
          expect(user.access_tokens.count).to eq 0
        end
      end
    end

    context "unauthorized user" do
      before :each do
        delete :signout, params: {}, format: :json
      end
      it "returns fail" do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
