module Api
  class ArticlesController < ApplicationController
    def show
      article = Article.find_by(slug: params[:slug])

      response = {
        article: {
          slug: article.slug,
          title: article.title,
          description: article.description,
          body: article.body,
          createdAt: article.created_at,
          updatedAt: article.updated_at,
          author: {
            username: article.user.username,
            bio: article.user.bio,
            image: article.user.image
          }
        }
      }

      if article
        render json: response
      else
        render json: { error: "Article not found" }, status: :not_found
      end
    end

    def create
      article_params = params.require(:article).permit(:title, :description, :body)

      # CookieからJWTを取得
      token = cookies[:token]

      # ユーザーの取得と認証チェック
      user = authenticate_user(token)

      article = user.articles.new(article_params)
      article.slug = generate_slug(article.title)
      article.created_at = Time.zone.now
      article.updated_at = Time.zone.now

      response = {
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

    def update
      article = Article.find_by(slug: params[:slug])

      # CookieからJWTを取得
      token = cookies[:token]

      # ユーザーの取得と認証チェック
      user = authenticate_user(token)

      if article.update(title: params[:article][:title])
        article.slug = generate_slug(article.title)
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
        render json: response
      else
        render json: { errors: article.errors }, status: :unprocessable_entity
      end
    end

    def destroy
      article = Article.find_by(slug: params[:slug])

      # CookieからJWTを取得
      token = cookies[:token]

      # ユーザーの取得と認証チェック
      user = authenticate_user(token)

      if article && user
        article.destroy
        head :no_content
      else
        head :unprocessable_entity
      end
    end

    private

    def generate_slug(title)
      title.downcase.gsub(/\s+/, "-")
    end
  end
end
