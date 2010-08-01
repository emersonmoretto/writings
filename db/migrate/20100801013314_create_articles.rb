class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.string :title
      t.date :date
      t.string :content
      t.string :author
      t.string :tags

      t.timestamps
    end
  end

  def self.down
    drop_table :articles
  end
end
