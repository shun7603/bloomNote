require 'rails_helper'

RSpec.describe "Settings", type: :request do
  let(:user) { create(:user) }

  before do
    sign_in user # ←これでログイン状態にする
  end

  describe "GET /notification" do
    it "returns http success" do
      get "/settings/notification"
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /subscribe" do
    it "returns http success" do
      post "/settings/subscribe", params: { user: { subscription_token: "dummy_token" } }
      expect(response).to have_http_status(:success)
    end
  end
end