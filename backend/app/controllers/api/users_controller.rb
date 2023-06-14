module Api
  class UsersController < ApplicationController
    def show
      # CookieからJWTを取得
      token = cookies[:token]

      # ユーザーの取得と認証チェック
      user = authenticate_user(token)

      if user.nil?
        render json: { message: 'unauthorized' }, status: :unauthorized
      else
        response = generate_user_response(user)
        render json: response, status: :ok
      end
    end

    def create
      # ユーザの作成
      user = User.create(username: params[:user][:username], email: params[:user][:email], password: params[:user][:password])

      response = generate_user_response(user)
      render json: response, status: :created
    rescue StandardError => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end
end
