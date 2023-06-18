module Api
  class ArticlesController < ApplicationController
    def show
      article = Article.find_by(slug: params[:slug])

      if article
        render json: generate_article_response(article), status: :ok
      else
        render json: { error: "Article not found" }, status: :not_found
      end
    end

    def create
      user = authenticate_user_from_token

      article = user.articles.new(article_params)
      article.slug = generate_slug(article.title)
      article.created_at = Time.zone.now
      article.updated_at = Time.zone.now

      if article.save
        render json: generate_article_response(article), status: :created
      else
        render json: { errors: article.errors }, status: :unprocessable_entity
      end
    end

    def update
      article = Article.find_by(slug: params[:slug])

      authenticate_user_from_token

      if article.update(article_params)
        article.slug = generate_slug(article.title)
        article.save!

        render json: generate_article_response(article), status: :ok
      else
        render json: { errors: article.errors }, status: :unprocessable_entity
      end
    end

    def destroy
      article = Article.find_by(slug: params[:slug])

      user = authenticate_user_from_token

      if article && user
        article.destroy
        head :no_content
      else
        head :unprocessable_entity
      end
    end

    private

    def article_params
      params.require(:article).permit(:title, :description, :body)
    end

    def authenticate_user_from_token
      token = cookies[:token]
      authenticate_user(token)
    end

    def generate_slug(title)
      title.downcase.gsub(/\s+/, "-")
    end

    def generate_article_response(article)
      {
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
    end
  end
end
