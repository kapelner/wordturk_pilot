
module DataDump
  SeparationChar = ','
  StrftimeForDates = '%m/%d/%y'
  StrftimeForTimes = '%H:%M:%S'

  #before running this make sure you have the lingua gem installed. It's in the lingua-0.5gem directory. Run "ruby install.rb"
  def DataDump.dump_disambiguations
    filename = "#{Rails.root}/data_analysis/disambiguations_dump_#{Time.now.strftime('%m_%d_%y__%H_%M')}.csv"
    write_out = File.new(filename, "w")
    #header
    row = %w(
      id
      created_at_time
      expired_at_time
      started_at_time
      read_consent_at_time
      finished_at_time
      time_to_read_consent
      time_spent
      mturk_worker_id
      comments_text
      comments_word_count
      worker_left_comment
      comments_word_count_total
      comments_word_count_average
      num_disambiguations_by_worker
      worker_did_more_than_one
      worker_did_more_than_two
      worker_did_more_than_three
      worker_did_more_than_four
      worker_did_more_than_five
      snippet_id
      corresct_sense_id
      snippet_context_num_words
      snippet_context_num_syllables
      snippet_context_num_chars
      snippet_context_kincaid_score
      snippet_context_fog_score
      target_word
      target_word_length
      target_word_is_noun
      num_senses_to_disambiguate
      correct_sense_num_words
      correct_sense_num_syllables
      correct_sense_num_chars
      correct_sense_kincaid_score
      correct_sense_fog_score
      response_sense_id
      correct
    )
    write_out.puts(row.join(SeparationChar))

    #run this as a find_each to get around the memory issues...
    Disambiguation.find_each(:batch_size => 50, :include => [:senseeval_inventory, {:snippet => {:word => :senseeval_inventories}}]) do |d|
      #only those completed
      next unless d.completed?
      #get some useful data
      s = d.snippet
      w = s.word
      next if w.senseeval_inventories.length == 1 #remove words with only one sense
      #now dump the data for this disambiguation
      row = []
      row << d.id
      row << d.created_at.to_i
      row << d.to_be_expired_at.to_i
      row << d.started_at.to_i
      row << (d.read_consent_at ? d.read_consent_at.to_i : '')
      row << d.finished_at.to_i
      row << d.time_to_read_consent
      row << d.time_spent
      row << d.mturk_worker_id
      #did the worker leave comments?
      row << DataDump.safe_string(d.comments)
      row << d.comments_word_count
      row << (d.comments_word_count > 0 ? 1 : 0)
      all_dis = Disambiguation.where(:mturk_worker_id => d.mturk_worker_id)
      total_comments_word_count = all_dis.inject(0){|sum, d| sum + d.comments_word_count}
      row << total_comments_word_count #how many combined comments did they leave?
      row << total_comments_word_count / all_dis.length.to_f #avg word count of comments
      #stuff for all disambiguations for this worker
      row << all_dis.length #how many disambiguations did they do?
      row << (all_dis.length > 1 ? 1 : 0) #did they do more than one?
      row << (all_dis.length > 2 ? 1 : 0)
      row << (all_dis.length > 3 ? 1 : 0)
      row << (all_dis.length > 4 ? 1 : 0)
      row << (all_dis.length > 5 ? 1 : 0)
      
      #snippet level stuff
      row << s.id
      row << s.senseeval_inventory_id
      readability_of_context = Lingua::EN::Readability.new(s.context)
      row << readability_of_context.num_words
      row << readability_of_context.num_syllables
      row << readability_of_context.num_chars
      row << readability_of_context.kincaid
      row << readability_of_context.fog
      #target word stuff
      row << w.entry
      row << w.entry.length
      row << (w.part_of_speech == 'n' ? 1 : 0)
      #all senses stuff
      row << w.senseeval_inventories.length #how many senses are there?
      #correct sense stuff
      readability_of_correct_sense_def = Lingua::EN::Readability.new(d.senseeval_inventory.basic_definition)
      row << readability_of_correct_sense_def.num_words
      row << readability_of_correct_sense_def.num_syllables
      row << readability_of_correct_sense_def.num_chars
      row << readability_of_correct_sense_def.kincaid
      row << readability_of_correct_sense_def.fog
      #Turker's answer
      row << d.senseeval_inventory.id
      row << (d.correct? ? 1 : 0)
      write_out.puts(row.join(SeparationChar))
    end

    #final stuff
    write_out.close
    filename
  end

  def DataDump.dump_snippets(snippets)
    filename = "#{Rails.root}/data_analysis/snippets_dump_#{Time.now.strftime('%m_%d_%y__%H_%M')}.csv"
    write_out = File.new(filename, "w")

    #header
    row = %w(id word part_of_speech correct_sense_id text)
    write_out.puts(row.join(SeparationChar))

    #now dump the data
    snippets.each do |s|
      row = []
      row << s.id
      row << s.word.entry
      row << s.word.part_of_speech
      row << s.senseeval_inventory_id
      row << DataDump.safe_string(s.context_as_text_with_target_marked)
      write_out.puts(row.join(SeparationChar))
    end

    #final stuff
    write_out.close
    filename
  end

  def DataDump.dump_senses(senses)
    filename = "#{Rails.root}/data_analysis/senses_dump_#{Time.now.strftime('%m_%d_%y__%H_%M')}.csv"
    write_out = File.new(filename, "w")

    #header
    row = %w(id word definition_text)
    write_out.puts(row.join(SeparationChar))

    #now dump the data
    senses.each do |s|
      row = []
      row << s.id
      row << s.word.entry
      row << DataDump.safe_string(s.basic_definition)
      write_out.puts(row.join(SeparationChar))
    end

    #final stuff
    write_out.close
    filename
  end
  
  private
  LinebreakToken = "<line>"
  DelimeterToken = "<com>"
  QuoteToken = "<qu>"
  def DataDump.safe_string(str)
    str = str.to_s.gsub("\r\n", LinebreakToken)
    str = str.to_s.gsub("\n", LinebreakToken)
    str = str.to_s.gsub("\r", LinebreakToken)
    str = str.to_s.gsub("\"", QuoteToken)
    str = str.to_s.gsub("'", QuoteToken)
    str = str.to_s.gsub(SeparationChar, DelimeterToken)
  end
end