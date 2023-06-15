class ApplicationController < ActionController::API
  include ActionController::Cookies

  private

  def generate_user_response(user)
    # ペイロードの作成
    payload = {
      iss: "RealWorld", # JWTの発行者
      sub: user.id, # JWTの主体
      exp: (DateTime.current + 14.days).to_i # JWTの有効期限
    }

    # 秘密鍵の取得
    rsa_private = OpenSSL::PKey::RSA.new(Rails.root.join('auth/service.key').read)

    # JWTの作成
    token = JWT.encode(payload, rsa_private, "RS256")

    # JWTをCookieにセット
    cookies[:token] = token

    {
      user: {
        email: user.email,
        token:,
        username: user.username,
        bio: user.bio,
        image: user.image
      }
    }
  end

  def authenticate_user(token)
    # 秘密鍵の取得
    rsa_private = OpenSSL::PKey::RSA.new(Rails.root.join('auth/service.key').read)

    # JWTのデコード。JWTからペイロードが取得できない場合は認証エラーにする
    begin
      decoded_token = JWT.decode(token, rsa_private, true, { algorithm: 'RS256' })
    rescue JWT::DecodeError, JWT::ExpiredSignature, JWT::VerificationError
      render json: { message: 'unauthorized' }, status: :unauthorized
    end

    # subクレームからユーザーIDを取得
    user_id = decoded_token.first["sub"]

    # ユーザーを検索
    User.find(user_id)
  end
end
