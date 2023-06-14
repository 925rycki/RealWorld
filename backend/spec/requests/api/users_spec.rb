require 'rails_helper'

RSpec.describe "Api::Users" do
  describe "POST /api/users" do
    subject(:create_user) do
      post api_users_path, params: {
        user: {
          username: "Jacob",
          email: "jake@jake.jake",
          password: "jakejake"
        }
      }
    end

    it 'api/usersにPOSTリクエストを送るとHTTPステータスコード201が返ること' do
      expect { create_user }.to change(User, :count).by(1)
    end

    it 'api/usersにPOSTリクエストを送るとcreatedステータスが返ること' do
      create_user
      expect(response).to have_http_status(:created)
    end
  end
end
