class WordPartOfSpeech < ActiveRecord::Migration
  def self.up
    add_column :words, :part_of_speech, :string, :length => 4
    add_index :words, :part_of_speech
  end

  def self.down
    remove_column :words, :part_of_speech
  end
end
