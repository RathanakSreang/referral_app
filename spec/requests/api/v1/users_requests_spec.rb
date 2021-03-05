require "rails_helper"

RSpec.describe Api::V1::UsersController, type: :controller do
  describe "GET #my_profile" do
    context "authorized user" do
      let!(:user) {FactoryBot.create :user}
      let!(:access_token) {FactoryBot.create :access_token, user: user}
      before :each do
        authentication_token access_token.token
        get :my_profile, params: {}, format: :json
      end
      it "returns user detail info" do
        expect(response).to be_successful
        expect(json_body["data"].keys).to match_array(["user"])
        expect(json_body["data"]["user"].keys).to match_array(["id", "name", "balance", "email", "referral_code"])
        expect(json_body["data"]["user"]["id"]).to eq(user.id)
      end
    end

    context "unauthorized user" do
      before :each do
        get :my_profile, params: {}, format: :json
      end
      it "returns fail" do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
