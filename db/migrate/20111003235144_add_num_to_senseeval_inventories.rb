class AddNumToSenseevalInventories < ActiveRecord::Migration
  def change
    add_column :senseeval_inventories, :n, :integer, :limit => 3  
  end
end
