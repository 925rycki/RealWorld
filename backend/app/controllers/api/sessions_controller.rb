module Api
  class SessionsController < ApplicationController
    def create
      # ユーザの取得
      user = User.find_by(email: params[:user][:email])&.authenticate(params[:user][:password])
      # user = User.create(username: params[:user][:username], email: params[:user][:email], password: params[:user][:password])

      # ペイロードの作成
      payload = {
        iss: "example_app", # JWTの発行者
        sub: user.id, # JWTの主体
        exp: (DateTime.current + 14.days).to_i # JWTの有効期限
      }

      # 秘密鍵の取得
      rsa_private = OpenSSL::PKey::RSA.new(Rails.root.join('auth/service.key').read)

      # JWTの作成
      token = JWT.encode(payload, rsa_private, "RS256")

      # JWTをCookieにセット
      cookies[:token] = token

      response = {
        user: {
          email: user.email,
          token:,
          username: user.username,
          bio: user.bio,
          image: user.image
        }
      }

      render json: response, status: :created
    end
  end
end
