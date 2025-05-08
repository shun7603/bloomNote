require 'rails_helper'

RSpec.describe "Children", type: :request do
  let(:user) { FactoryBot.create(:user) }

  before do
    sign_in user
  end

  describe "GET /new" do
    it "returns http success" do
      get new_child_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /index" do
    it "returns http success" do
      get children_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /create" do
    it "returns http redirect" do
      post children_path, params: {
        child: {
          name: "テストちゃん",
          birth_date: "2020-01-01",
          gender: "girl"
        }
      }
      expect(response).to redirect_to(root_path) # 必要に応じて修正
    end
  end
end