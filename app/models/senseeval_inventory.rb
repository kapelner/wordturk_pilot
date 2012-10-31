class SenseevalInventory < ActiveRecord::Base
  validates :word_id, :presence => true
  validates :basic_definition, :presence => true
  serialize :examples

  belongs_to :word

  def SenseevalInventory.create_all_from_word_data_files!
    Word.all.each do |w|
      w.create_senseval_inventories!
    end
  end

  
end
