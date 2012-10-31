class WordsController < ApplicationController
  before_filter :admin_required
  
  def index
    @words = Word.all(:order => :entry)
  end

end
