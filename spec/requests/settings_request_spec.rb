require 'rails_helper'

RSpec.describe "Settings", type: :request do

  describe "GET /notification" do
    it "returns http success" do
      get "/settings/notification"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /subscribe" do
    it "returns http success" do
      get "/settings/subscribe"
      expect(response).to have_http_status(:success)
    end
  end

end
