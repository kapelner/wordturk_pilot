class Snippet < ActiveRecord::Base
  include ActiveModel::Validations
  
  belongs_to :word
  belongs_to :senseeval_inventory #ie the ONE CORRECT sense
  has_many :disambiguations
  
  serialize :examples

  validates :word_id, :presence => true
  validates :context, :presence => {:message => "Snippet must have a context."}

  #scopes that we want
  scope :experimentals, where(:experimental => true)

  TargetWordIndicator = "ABFUNEDNYJDGYMDFENUJIOFVRHJDFBDTJSDVETJDFVSEHDJSDVSDTJNSDVRDJSDFBSDGHDRJSDVSREHNDRHJDBSDHDRHNDRBSDFNDFBDFHDFHDFBDFB"
  NewXMLFileAfterSubbing = "new_all_snippets.xml"
  def Snippet.generate_new_xml_file!
    str = Nokogiri::XML(File.open("data/all_training_snippets.xml")).to_xml
    str = str.gsub("<head> ", TargetWordIndicator).gsub(" </head>", TargetWordIndicator)
    File.open("data/#{NewXMLFileAfterSubbing}", "w"){|f| f.puts(str)}
    puts "done!!"
  end

  def senseeval_inventories
    self.word.senseeval_inventories
  end
  
  def Snippet.create_all_from_data!
    xml = Nokogiri::XML(File.open("data/#{NewXMLFileAfterSubbing}"))
    lexs = xml.xpath("//lexelt")

    lexs.each do |lex|
      word = lex["item"].split(".").first #Example: affect.v
      w = Word.find_by_entry(word, :include => :senseeval_inventories)
      p "word we're making snippets for: #{word}"

      instances = lex.xpath(".//instance")
      instances.each do |instance|
          senseID = instance.xpath(".//answer").first["senseid"]          
          senseeval_inventory = w.find_sense_with_id(senseID.to_i)
          context = instance.xpath(".//context").text.strip
          context = context.gsub(/ \./, ".").gsub(/ ,/, ",").gsub(/ '/, "'").gsub(/` /, "`").gsub(/ ;/, ";").gsub(/`/, "'").gsub(/''/, %Q|"|).gsub( %Q| %|, "%").gsub( %Q|$ |, "$").gsub(%Q| )|, ")").gsub(%Q|( |, "(").gsub(%Q|does n't|, "doesn't").gsub(%Q|was n't|, "wasn't")
          #go ahead and create the row in the db
          Snippet.create(:word_id => w.id, :senseeval_inventory_id => senseeval_inventory.id, :context => context)
      end      
    end
  end

  def not_disambiguated_fully?
    num_disambiguations_left.zero?
  end

  def num_disambiguations_left
    #include a correction for negative numbers
    [Disambiguation::NUM_DISAMBIGUATIONS_PER_SNIPPET - self.disambiguations.select{|d| d.completed?}.size, 0].max
  end

  def Snippet.snippet_text_for_display(context)
    context.sub(TargetWordIndicator, %Q|<span class="emboldened_word">|).sub(TargetWordIndicator, %Q|</span>|)
  end

  def context_as_text_with_target_marked
    self.context.gsub(TargetWordIndicator, '**')
  end

  def context_as_text
    self.context.gsub(TargetWordIndicator, '')
  end

  NUM_SNIPPETS_IN_EXP = 1000
  def Snippet.randomize_for_experiment!
    all_snippets = Snippet.all.sort_by{rand} #sampling frame
    all_snippets[0...NUM_SNIPPETS_IN_EXP].each{|s| s.update_attributes(:experimental => true)} #set experimental
    all_snippets[NUM_SNIPPETS_IN_EXP..-1].each{|s| s.update_attributes(:experimental => false)} #set not experimental
  end

  def Snippet.unique_experimental_senses
    Snippet.experimentals.includes(:word).inject({}){|hash, s| hash[s.word.entry] = s; hash}.values.map{|s| s.senseeval_inventories}.flatten
  end

  def best_guess
    #hash of senseeval_id --> num guesses
    hash = self.disambiguations.map{|d| d.senseeval_inventory_id}.inject({}) do |hash, se_id|
      hash[se_id] ||= 0
      hash[se_id] += 1
      hash
    end
    #now pick the max num guesses and return all keys
    max_num_guesses = hash.values.max
    possible_answers = []
    hash.each do |se_id, num_guesses|
      possible_answers << se_id if num_guesses == max_num_guesses
    end
    #if there's a tie return one randomly
    guess = possible_answers.sample
    p "Snippet #{self.id} all guesses: #{hash}  guess: #{guess}  right answer #{self.senseeval_inventory_id} correct? #{guess == self.senseeval_inventory_id ? 'Y' : ''}"
    guess
  end

  def Snippet.prop_correct_answers
    snippets = Snippet.experimentals
    num_correct = snippets.inject(0) do |sum, s|
      sum + (s.best_guess == s.senseeval_inventory_id ? 1 : 0)
    end
    num_correct / snippets.length.to_f
  end

  def Snippet.generate_all_data_from_scratch!
    p "generate all words"
    Word.load_words_from_senseval_data!
    p "load senses for words"
    SenseevalInventory.create_all_from_word_data_files!
    p "generate new XML file"
    Snippet.generate_new_xml_file!
    p "load snippets"
    Snippet.create_all_from_data!
    p "randomize for experimentation"
    Snippet.randomize_for_experiment!
    p "done!"
  end
end
