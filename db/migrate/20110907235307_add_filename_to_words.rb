class AddFilenameToWords < ActiveRecord::Migration
  def self.up
    add_column :words, :sense_inventory_filename, :string
  end

  def self.down
    add_column :words, :sense_inventory_filename
  end
end
