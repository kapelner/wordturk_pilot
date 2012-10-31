class CreateBigBrotherTracks < ActiveRecord::Migration
  def self.up
    create_table :big_brother_tracks do |t|
      t.column :mturk_worker_id, :string
      t.column :ip, :string
      t.column :controller, :string
      t.column :action, :string
      t.column :method, :string
      t.column :ajax, :boolean
      t.column :created_at, :datetime
    end
    add_index :big_brother_tracks, :ip
    add_index :big_brother_tracks, :mturk_worker_id
  end

  def self.down
    drop_table :big_brother_tracks
  end
end
