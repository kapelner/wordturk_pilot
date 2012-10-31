class CreateBrowserStatuses < ActiveRecord::Migration
  def self.up
    create_table :browser_statuses do |t|
      t.integer :disambiguation_id
      t.string :status
      t.datetime :created_at
    end
    add_index :browser_statuses, :disambiguation_id
  end

  def self.down
    drop_table :browser_statuses
  end
end
