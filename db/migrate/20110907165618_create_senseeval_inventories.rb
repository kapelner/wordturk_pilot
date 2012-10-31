class CreateSenseevalInventories < ActiveRecord::Migration
  def self.up
    create_table :senseeval_inventories do |t|
      t.integer :word_id
      t.string :basic_definition
      t.text :commentary
      t.text :examples
      t.timestamps
    end
  end

  def self.down
    drop_table :senseeval_inventories
  end
end
