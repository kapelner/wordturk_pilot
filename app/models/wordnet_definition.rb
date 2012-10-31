class WordnetDefinition < ActiveRecord::Base
  belongs_to :word
  has_many :snippets
  has_many :disambiguations

  validates :word_id, :presence => true
  validates :definition_text, :presence => true
end
