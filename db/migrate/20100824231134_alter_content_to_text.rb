class AlterContentToText < ActiveRecord::Migration
  def self.up
    remove_column :articles, :content
    add_column :articles, :content, :text
  
  end

  def self.down
  end
end
