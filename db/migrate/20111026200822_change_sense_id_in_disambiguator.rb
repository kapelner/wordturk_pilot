class ChangeSenseIdInDisambiguator < ActiveRecord::Migration
  def up
    remove_column :disambiguations, :wordnet_definition_id
    add_column :disambiguations, :senseeval_inventory_id, :integer
  end

  def down
    remove_column :disambiguations, :senseeval_inventory_id
    add_column :disambiguations, :wordnet_definition_id, :integer    
  end
end
