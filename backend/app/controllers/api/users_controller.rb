module Api
  class UsersController < ApplicationController
    def show
      # CookieからJWTを取得
      token = cookies[:token]

      # 秘密鍵の取得
      rsa_private = OpenSSL::PKey::RSA.new(Rails.root.join('auth/service.key').read)

      # JWTのデコード。JWTからペイロードが取得できない場合は認証エラーにする
      begin
        decoded_token = JWT.decode(token, rsa_private, true, { algorithm: 'RS256' })
      rescue JWT::DecodeError, JWT::ExpiredSignature, JWT::VerificationError
        return render json: { message: 'unauthorized' }, status: :unauthorized
      end

      # subクレームからユーザーIDを取得
      user_id = decoded_token.first["sub"]

      # ユーザーを検索
      user = User.find(user_id)

      # userが取得できた場合はユーザー情報を返す、取得できない場合は認証エラー
      if user.nil?
        render json: { message: 'unauthorized' }, status: :unauthorized
      else
        response = {
          user: {
            email: user.email,
            token:,
            username: user.username,
            bio: user.bio,
            image: user.image
          }
        }
  
        render json: response, status: :ok
      end
    end

    def create
      begin
        # ユーザの作成
        user = User.create(username: params[:user][:username], email: params[:user][:email], password: params[:user][:password])
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
      rescue => e
        render json: { error: e.message }, status: :unprocessable_entity
      end
    end
    
  end
end
