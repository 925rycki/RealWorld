class ApplicationController < ActionController::API
  include ActionController::Cookies

  private

  def generate_user_response(user)
    payload = {
      iss: "RealWorld",
      sub: user.id,
      exp: (DateTime.current + 14.days).to_i
    }

    rsa_private = OpenSSL::PKey::RSA.new(Rails.root.join('auth/service.key').read)

    token = JWT.encode(payload, rsa_private, "RS256")

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
    rsa_private = OpenSSL::PKey::RSA.new(Rails.root.join('auth/service.key').read)

    begin
      decoded_token = JWT.decode(token, rsa_private, true, { algorithm: 'RS256' })
    rescue JWT::DecodeError, JWT::ExpiredSignature, JWT::VerificationError
      render json: { message: 'unauthorized' }, status: :unauthorized
    end

    user_id = decoded_token.first["sub"]

    User.find(user_id)
  end
end
