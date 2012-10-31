class CreateDisambiguations < ActiveRecord::Migration
  def self.up
    create_table :disambiguations do |t|
      t.integer :snippet_id
      t.integer :wordnet_definition_id
      #now we go for the heavy stuff
      #autopopulated
      t.string :mturk_hit_id
      t.string :mturk_group_id
      t.integer :version, :limit => 3
      t.float :wage #not really necessary, but store anyway
      t.string :country, :limit => 2
      t.datetime :to_be_expired_at
      t.integer :treatment, :limit => 3 #not used
      #populated when hit is accepted      
      t.string :mturk_assignment_id
      t.string :mturk_worker_id
      t.string :ip_address
      t.datetime :started_at
      #and after they finish the consent and directions
      t.datetime :read_consent_at
      t.integer :age, :limit => 3
      t.string :gender, :limit => 1
      t.datetime :read_directions_at
      #and when they finish it
      t.datetime :finished_at
      #their browser
      t.text :browser_info
      #their feedback
      t.text :comments
      #for our own notes
      t.text :notes
      #populated when hit is checked over by admin
      t.datetime :rejected_at
      t.datetime :paid_at
      t.float :bonus
      t.timestamps
    end

    add_index :disambiguations, :snippet_id
    add_index :disambiguations, :mturk_hit_id
    add_index :disambiguations, :mturk_worker_id
  end

  def self.down
    drop_table :disambiguations
  end
end
