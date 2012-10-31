require 'nokogiri'
require 'open-uri'

class Word < ActiveRecord::Base
  include AllWords

  has_many :snippets
  has_many :senseeval_inventories

  validates :entry, :presence => true
  validates :version, :presence => true

  def Word.load_words_from_senseval_data!
    Dir.entries("data/sense-inventories").each do |word_filename|
      word_parts = word_filename.split(".xml").last.split("-")
      Word.create({
        :entry => word_parts.first,
        :part_of_speech => word_parts.last,
        :sense_inventory_filename => word_filename,
        :version => 1
      }) unless %w(. ..).include?(word_filename)
    end

    #num senses
    num = 0
    SenseevalInventory.all.each do |inv|
      if(inv.word_id == 1)
        num += 1
      end
    end
    #num snippets
    num_snip = 0
    Snippet.all.each do |snip|
      if(snip.senseeval_inventory_id == 1)
        num_snip += 1
      end
    end

    counter = 0

    File.open('data/words_by_num_snippets.csv', 'w') do |f|
    
      Word.all.each do |wrd|
        if (counter > 86)
          if (counter < 120)
            a = []
            a << wrd.entry

            SenseevalInventory.all.each do |inv|
              if(inv.word_id == wrd.id)
                num_snip = 0

                Snippet.all.each do |snip|
                  if(snip.senseeval_inventory_id == inv.id)
                    num_snip += 1
                  end

                end

                a << num_snip
              end
            end

            a.each do |item|
              f << item
              f << ","
            end

            f.puts()

          end
        end
        counter += 1
      end

    end
      

  end

  def create_senseval_inventories!
    xml_parse = Nokogiri::HTML(File.open("data/sense-inventories/#{self.sense_inventory_filename}"))
    senses = xml_parse.xpath("//sense")
    senses.each_with_index do |sense, n|
      SenseevalInventory.create({
        :word_id => self.id,
        :n => n + 1,
        :basic_definition => sense["name"],
        :commentary => sense.xpath(".//commentary").text.strip,
        :examples => sense.xpath(".//examples").text.split("\r\n").map{|ex| ex.strip}.slice(1..-2)
      })
    end
  end

  def hist!
    File.open('data/words_by_num_snippets.csv', 'w') do |f|
      Word.all.each do |w|
        f.puts("#{w.entry},#{w.num_snippets(w.id)}") #you'll probably have to write num_snippets or figure out how to do it with some snazzy Rails 3.1 doohickey
      end
    end
  end

  def find_sense_with_id(n)
    self.senseeval_inventories.detect{|sense| sense.n == n}
  end

end
