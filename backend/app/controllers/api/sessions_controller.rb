module Api
  class SessionsController < ApplicationController
    def create
      user = User.find_by(email: params[:user][:email])&.authenticate(params[:user][:password])

      # userがnilの場合の例外処理
      unless user
        render json: { message: 'unauthorized' }, status: :unauthorized
        return
      end

      response = generate_user_response(user)
      render json: response, status: :created
    end
  end
end
