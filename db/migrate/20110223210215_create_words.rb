class CreateWords < ActiveRecord::Migration
  def self.up
    create_table :words do |t|
      t.string :entry
      t.string :url, :limit => 500
      t.integer :version, :null => false, :default => 1, :limit => 3
      t.datetime :created_at
    end
    add_index :words, :entry
  end

  def self.down
    drop_table :words
  end
end
