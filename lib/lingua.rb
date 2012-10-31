module Lingua
module EN

  # The module Lingua::EN::Syllable contains a single class method, +syllable+,
  # which will use the most accurate technique available to determine the number
  # syllables in a string containing a word passed to it.
  # The exact definition of the function depends on the availability of the
  # Carnegie Mellon Pronouncing Dictionary on the system. If it is available,
  # the number of syllables as determined by the dictionary will be returned. If
  # the dictionary is not available, or if a word not contained in the dictionary
  # is passed, it will return the number of syllables as determined by the
  # module Lingua::EN::Syllable::Guess. For more details, see there and
  # Lingua::EN::Syllable::Dictionary.
  module Syllable
    # use dictionary if possible
    begin

      def Syllable.syllables(word)
        begin
          return Dictionary::syllables(word)
        rescue Dictionary::LookUpError
          return Guess::syllables(word)
        end
      end
    rescue LoadError # dictionary not available?
      require 'lingua/en/syllable/guess.rb'
      def Syllable.syllables(word)
        Guess::syllables word
      end
    end
  end

  if __FILE__ == $0
    ARGV.each { | word |  puts "'#{word}' : " +
      Lingua::EN::Syllable::syllables(word).to_s }
  end

  # Uses english word patterns to guess the number of syllables. A single module
  # method is made available, +syllables+, which, when passed an english word,
  # will return the number of syllables it estimates are in the word.
  # English orthography (the representation of spoken sounds as written signs) is
  # not regular. The same spoken sound can be represented in multiple different
  # ways in written English (e.g. rough/cuff), and the same written letters
  # can be pronounced in different ways in different words (e.g. rough/bough).
  # As the same series of letters can be pronounced in different ways, it is not
  # possible to write an algorithm which can always guess the number of syllables
  # in an english word correctly. However, it is possible to use frequently
  # recurring patterns in english (such as "a final -e is usually silent") to
  # guess with a level of accuracy that is acceptable for applications like
  # syllable counting for readability scoring. This module implements such an
  # algorithm.
  # This module is inspired by the Perl Lingua::EN::Syllable module. However, it
  # uses a different (though not larger) set of patterns to compensate for the
  # 'special cases' which arise out of English's irregular orthography. A number
  # of extra patterns (particularly for derived word forms) means that this module
  # is somewhat more accurate than the Perl original. It also omits a number of
  # patterns found in the original which seem to me to apply to such a small number
  # of cases, or to be of dubious value. Testing the guesses against the Carnegie
  # Mellon Pronouncing Dictionary, this module guesses right around 90% of the
  # time, as against about 85% of the time for the Perl module. However, the
  # dictionary contains a large number of foreign loan words and proper names, and
  # so when the algorithm is tested against 'real world' english, its accuracy
  # is a good deal better. Testing against a range of samples, it guesses right
  # about 95-97% of the time.

  module Guess
    # special cases - 1 syllable less than expected
    SubSyl = [
      /[^aeiou]e$/, # give, love, bone, done, ride ...
      /[aeiou](?:([cfghklmnprsvwz])\1?|ck|sh|[rt]ch)e[ds]$/,
      # (passive) past participles and 3rd person sing present verbs:
      # bared, liked, called, tricked, bashed, matched

      /.e(?:ly|less(?:ly)?|ness?|ful(?:ly)?|ments?)$/,
      # nominal, adjectival and adverbial derivatives from -e$ roots:
      # absolutely, nicely, likeness, basement, hopeless
      # hopeful, tastefully, wasteful

      /ion/, # action, diction, fiction
      /[ct]ia[nl]/, # special(ly), initial, physician, christian
      /[^cx]iou/, # illustrious, NOT spacious, gracious, anxious, noxious
      /sia$/, # amnesia, polynesia
      /.gue$/ # dialogue, intrigue, colleague
    ]

    # special cases - 1 syllable more than expected
    AddSyl = [
      /i[aiou]/, # alias, science, phobia
      /[dls]ien/, # salient, gradient, transient
      /[aeiouym]ble$/, # -Vble, plus -mble
      /[aeiou]{3}/, # agreeable
      /^mc/, # mcwhatever
      /ism$/, # sexism, racism
      /(?:([^aeiouy])\1|ck|mp|ng)le$/, # bubble, cattle, cackle, sample, angle
      /dnt$/, # couldn/t
      /[aeiou]y[aeiou]/ # annoying, layer
    ]

    # special cases not actually used - these seem to me to be either very
    # marginal or actually break more stuff than they fix
    NotUsed = [
      /^coa[dglx]./, # +1 coagulate, coaxial, coalition, coalesce - marginal
      /[^gq]ua[^auieo]/, # +1 'du-al' - only for some speakers, and breaks
      /riet/, # variety, parietal, notoriety - marginal?
    ]

    def Guess.syllables(word)
      return 1 if word.length == 1
      word = word.downcase.delete("'")

      syllables = word.scan(/[aeiouy]+/).length

      # special cases
      for pat in SubSyl
        syllables -= 1 if pat.match(word)
      end
      for pat in AddSyl
        syllables += 1 if pat.match(word)
      end

      syllables = 1 if syllables < 1 # no vowels?
      syllables
    end
  end

  module Dictionary
    class LookUpError < IndexError
    end

    @@dictionary = nil
    @@dbmclass   = nil
    @@dbmext     = nil

    # use an available dbm-style hash
    require 'dbm'
    @@dbmclass = Module.const_get('DBM')

    if @@dbmclass.nil?
      raise LoadError,
        "no dbm class available for Lingua::EN::Syllable::Dictionary"
    end

    # Look up word in the dbm dictionary.
    def Dictionary.syllables(word)
      if @@dictionary.nil?
        load_dictionary
      end
      word = word.upcase
      begin
        pronounce = @@dictionary.fetch(word)
      rescue IndexError
        if word =~ /'/
          word = word.delete "'"
          retry
        end
        raise LookUpError, "word #{word} not in dictionary"
      end

      pronounce.split(/-/).grep(/^[AEIUO]/).length
    end

    def Dictionary.dictionary
      if @@dictionary.nil?
        load_dictionary
      end
      @@dictionary
    end

    # convert a text file dictionary into dbm files. Returns the file names
    # of the created dbms.
    def Dictionary.make_dictionary(source_file, output_dir)
      begin
        Dir.mkdir(output_dir)
      rescue
      end

      # clean old dictionary dbms
      Dir.foreach(output_dir) do | x |
        next if x =~ /^\.\.?$/
        File.unlink(File.join(output_dir, x))
      end

      dbm = @@dbmclass.new(File.join(output_dir, 'dict'))

      begin
        IO.foreach(source_file) do | line |
          next if line !~ /^[A-Z]/
          line.chomp!
          (word, *phonemes) = line.split(/  ?/)
          next if word =~ /\(\d\) ?$/ # ignore alternative pronunciations
          dbm.store(word, phonemes.join("-"))
        end
      rescue
        # close and clean up
        dbm.close
        Dir.foreach(output_dir) do | x |
          next if x =~ /^\.\.?$/
          File.unlink(File.join('dict', x))
        end
        # delete files
        raise
      end

      dbm.close

      Dir.entries(output_dir).collect { | x |
        x =~ /^\.\.?$/ ? nil : File.join("dict", x)
      }.compact
    end

    private
    def Dictionary.load_dictionary
      @@dictionary = @@dbmclass.new( __FILE__[0..-14] + 'dict')
      if @@dictionary.keys.length.zero?
        raise LoadError, "dictionary file not found"
      end
    end
  end

  # The module Lingua::EN::Sentence takes English text, and attempts to split it
  # up into sentences, respecting abbreviations.

  module Sentence
    EOS = "\001" # temporary end of sentence marker

    Titles   = [ 'jr', 'mr', 'mrs', 'ms', 'dr', 'prof', 'sr', 'sen', 'rep',
           'rev', 'gov', 'atty', 'supt', 'det', 'rev', 'col','gen', 'lt',
           'cmdr', 'adm', 'capt', 'sgt', 'cpl', 'maj' ]

    Entities = [ 'dept', 'univ', 'uni', 'assn', 'bros', 'inc', 'ltd', 'co',
           'corp', 'plc' ]

    Months   = [ 'jan', 'feb', 'mar', 'apr', 'may', 'jun', 'jul',
           'aug', 'sep', 'oct', 'nov', 'dec', 'sept' ]

    Days     = [ 'mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun' ]

    Misc     = [ 'vs', 'etc', 'no', 'esp', 'cf' ]

    Streets  = [ 'ave', 'bld', 'blvd', 'cl', 'ct', 'cres', 'dr', 'rd', 'st' ]

    @@abbreviations = Titles + Entities + Months + Days + Streets + Misc

    # Split the passed text into individual sentences, trim these and return
    # as an array. A sentence is marked by one of the punctuation marks ".", "?"
    # or "!" followed by whitespace. Sequences of full stops (such as an
    # ellipsis marker "..." and stops after a known abbreviation are ignored.
    def Sentence.sentences(text)

      text = text.dup

      # initial split after punctuation - have to preserve trailing whitespace
      # for the ellipsis correction next
      # would be nicer to use look-behind and look-ahead assertions to skip
      # ellipsis marks, but Ruby doesn't support look-behind
      text.gsub!( /([\.?!](?:\"|\'|\)|\]|\})?)(\s+)/ ) { $1 << EOS << $2 }

      # correct ellipsis marks and rows of stops
      text.gsub!( /(\.\.\.*)#{EOS}/ ) { $1 }

      # correct abbreviations
      # TODO - precompile this regex?
      text.gsub!( /(#{@@abbreviations.join("|")})\.#{EOS}/i ) { $1 << '.' }

      # split on EOS marker, strip gets rid of trailing whitespace
      text.split(EOS).map { | sentence | sentence.strip }
    end

    # add a list of abbreviations to the list that's used to detect false
    # sentence ends. Return the current list of abbreviations in use.
    def Sentence.abbreviation(*abbreviations)
      @@abbreviations += abbreviations
      @@abbreviations
    end
  end


  # The class Lingua::EN::Readability takes English text and analyses formal
  # characteristic
  class Readability
    include Syllable
    include Guess

    attr_reader :text, :paragraphs, :sentences, :words,  :frequencies

    # The constructor accepts the text to be analysed, and returns a report
    # object which gives access to the
    def initialize(text)
      @text                = text.dup
      @paragraphs          = text.split(/\n\s*\n\s*/)
      @sentences           = Lingua::EN::Sentence.sentences(@text)
      @words               = []
      @frequencies         = {}
      @frequencies.default = 0
      @syllables           = 0
      @complex_words       = 0
      count_words
    end

    # The number of paragraphs in the sample. A paragraph is defined as a
    # newline followed by one or more empty or whitespace-only lines.
    def num_paragraphs
      @paragraphs.length
    end

    # The number of sentences in the sample. The meaning of a "sentence" is
    # defined by Lingua::EN::Sentence.
    def num_sentences
      @sentences.length
    end

    # The number of characters in the sample.
    def num_chars
      @text.length
    end
    alias :num_characters :num_chars

    # The total number of words used in the sample. Numbers as digits are not
    # counted.
    def num_words
      @words.length
    end

    # The total number of syllables in the text sample. Just for completeness.
    def num_syllables
      @syllables
    end

    # The number of different unique words used in the text sample.
    def num_unique_words
      @frequencies.keys.length
    end

    # An array containing each unique word used in the text sample.
    def unique_words
      @frequencies.keys
    end

    # The number of occurences of the word +word+ in the text sample.
    def occurrences(word)
      @frequencies[word]
    end

    # The average number of words per sentence.
    def words_per_sentence
      @words.length.to_f / @sentences.length.to_f
    end

    # The average number of syllables per word. The syllable count is performed
    # by Lingua::EN::Syllable, and so may not be completely accurate, especially
    # if the Carnegie-Mellon Pronouncing Dictionary is not installed.
    def syllables_per_word
      @syllables.to_f / @words.length.to_f
    end

    # Flesch-Kincaid level of the text sample. This measure scores text based
    # on the American school grade system; a score of 7.0 would indicate that
    # the text is readable by a seventh grader. A score of 7.0 to 8.0 is
    # regarded as optimal for ordinary text.
    def kincaid
      (11.8 * syllables_per_word) +  (0.39 * words_per_sentence) - 15.59
    end

    # Flesch reading ease of the text sample. A higher score indicates text that
    # is easier to read. The score is on a 100-point scale, and a score of 60-70
    # is regarded as optimal for ordinary text.
    def flesch
      206.835 - (1.015 * words_per_sentence) - (84.6 * syllables_per_word)
    end

    # The Gunning Fog Index of the text sample. The index indicates the number
    # of years of formal education that a reader of average intelligence would
    # need to comprehend the text. A higher score indicates harder text; a value
    # of around 12 is indicated as ideal for ordinary text.
    def fog
      ( words_per_sentence +  percent_fog_complex_words ) * 0.4
    end

    # The percentage of words that are defined as "complex" for the purpose of
    # the Fog Index. This is non-hyphenated words of three or more syllabes.
    def percent_fog_complex_words
      ( @complex_words.to_f / @words.length.to_f ) * 100
    end

    # Return a nicely formatted report on the sample, showing most the useful
    # statistics about the text sample.
    def report
      sprintf "Number of paragraphs           %d \n" <<
          "Number of sentences            %d \n" <<
          "Number of words                %d \n" <<
          "Number of characters           %d \n\n" <<
          "Average words per sentence     %.2f \n" <<
          "Average syllables per word     %.2f \n\n" <<
          "Flesch score                   %2.2f \n" <<
          "Flesh-Kincaid grade level      %2.2f \n" <<
          "Fog Index                      %2.2f \n",
          num_paragraphs, num_sentences, num_words, num_characters,
          words_per_sentence, syllables_per_word,
          flesch, kincaid, fog
    end

    private
    def count_words
      for match in @text.scan /\b([a-z][a-z\-']*)\b/i
        word = match[0]
        @words.push word
        @frequencies[word] += 1
        syllables = Lingua::EN::Syllable.syllables(word)
        @syllables += syllables
        if syllables > 2 && word !~ /-/
          @complex_words += 1 # for Fog Index
        end
      end
    end
  end
end
end
