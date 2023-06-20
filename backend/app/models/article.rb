class Article < ApplicationRecord
  validates :title, :description, :body, presence: true
  belongs_to :user
end
