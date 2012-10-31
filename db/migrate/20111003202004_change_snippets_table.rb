class ChangeSnippetsTable < ActiveRecord::Migration
  def up
    drop_table :snippets
    create_table :snippets do |t|
      t.integer :word_id
      t.integer :senseeval_inventory_id
      t.text :context
    end
  end

  def down
    drop_table :snippets
    create_table :snippets do |t|
      t.integer :word_id
      t.integer :correct_wordnet_definition_id
      t.integer :news_article_id
      t.text :context
      t.text :url
      t.timestamps
    end
  end
end
