class AdminController < ExperimentalAdminController

  def index
    main_console
  end
  
  def sync_wordlist
    Word.sync_wordlist_and_definitions_to_database
    render :text => "synced to words version #{AllWords::AllWordsVer}. #{Word.count} words in database with #{WordnetDefinition.count} definitions."
  end

  def create_hit_set
    Disambiguation.create_hitset_with_words_and_post!
    redirect_to :action => :index
  end

end