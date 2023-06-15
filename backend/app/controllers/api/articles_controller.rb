class Api::ArticlesController < ApplicationController
  def create
    article_params = params.require(:article).permit(:title, :description, :body)

    # CookieからJWTを取得
    token = cookies[:token]

    # ユーザーの取得と認証チェック
    user = authenticate_user(token)

    article = user.articles.new(article_params)
    article.slug = generate_slug(article.title)
    article.created_at = Time.now
    article.updated_at = Time.now

    response =     {
      article: {
        slug: article.slug,
        title: article.title,
        description: article.description,
        body: article.body,
        createdAt: article.created_at,
        updatedAt: article.updated_at,
        author: {
          username: user.username,
          bio: user.bio,
          image: user.image
        }
      }
    }

    if article.save
      render json: response, status: :created
    else
      render json: { errors: article.errors }, status: :unprocessable_entity
    end
  end

  private

  def generate_slug(title)
    slug = title.downcase.gsub(/\s+/, "-")
    slug
  end
end

