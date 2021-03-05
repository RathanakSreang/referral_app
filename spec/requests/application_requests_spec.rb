require "rails_helper"

RSpec.describe ApplicationController, type: :controller do
  let(:user) {FactoryBot.create :user}
  let(:access_token) {FactoryBot.create :access_token, user: user}
  describe "#current_access_tokens" do
    context "access token not exist" do
      it "should return nil" do
        expect(controller.current_access_tokens).to eq nil
      end
    end

    context "access token exist" do
      context "valid access token" do
        before {authentication_token access_token.token}
        it "should returns access_token" do
          expect(controller.current_access_tokens.id).to eq access_token.id
        end
      end

      context "invalid access token" do
        before {authentication_token "unknown"}
        it "should return nil if token not found" do
          expect(controller.current_access_tokens).to eq nil
        end
      end
    end
  end

  describe "#current_user" do
    it "should return user if current_access_tokens exist" do
      allow(controller).to receive(:current_access_tokens).and_return(access_token)
      expect(controller.current_user.id).to eq user.id
    end

    it "should return user if current_access_tokens not exist" do
      allow(controller).to receive(:current_access_tokens).and_return(nil)
      expect(controller.current_user).to eq nil
    end
  end

  describe "#logged_in?" do
    let(:user) {FactoryBot.create :user}
    it "should return true if current_user exist" do
      allow(controller).to receive(:current_user).and_return(user)
      expect(controller.logged_in?).to eq true
    end

    it "should return false if current_user not exist" do
      allow(controller).to receive(:current_user).and_return(nil)
      expect(controller.logged_in?).to eq false
    end
  end

  describe "#authorized" do
  end
end
