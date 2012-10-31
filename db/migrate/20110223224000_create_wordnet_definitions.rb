class CreateWordnetDefinitions < ActiveRecord::Migration
  def self.up
    create_table :wordnet_definitions do |t|
      t.integer :word_id
      t.text :definition_text
      t.timestamps
    end

    add_index :wordnet_definitions, :word_id
  end

  def self.down
    drop_table :wordnet_definitions
  end
end
