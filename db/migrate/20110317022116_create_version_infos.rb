class CreateVersionInfos < ActiveRecord::Migration
  def self.up
    create_table :version_infos do |t|
      t.integer :version
      t.text :description
      t.timestamps
    end
    add_index :version_infos, :version
    #create one to get started
    VersionInfo.create(:version => 1)
  end

  def self.down
    drop_table :version_infos
  end
end
