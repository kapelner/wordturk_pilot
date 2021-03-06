class CreateSnippets < ActiveRecord::Migration
  def self.up
    create_table :snippets do |t|
      t.integer :word_id
      t.integer :correct_wordnet_definition_id
      t.integer :news_article_id
      t.text :context
      t.text :url
      t.timestamps
    end
  end

  def self.down
    drop_table :snippets
  end
end
