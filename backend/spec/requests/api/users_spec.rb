require 'rails_helper'

RSpec.describe "Api::Users" do
  describe "POST /api/users" do
    it 'POST api/usersした場合、HTTPステータスコード201が返ってくる' do
      post api_users_path, params:
      {
        user: {
          username: "Jacob",
          email: "jake@jake.jake",
          password: "jakejake"
        }
      }
      expect(response).to have_http_status(:created)
    end
  end
end
