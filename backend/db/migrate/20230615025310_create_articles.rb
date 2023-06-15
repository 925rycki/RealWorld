class CreateArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :articles do |t|
      t.string :slug
      t.string :title
      t.string :description
      t.string :body

      t.timestamps
    end
  end
end
