class SnippetsController < ApplicationController
  before_filter :admin_required

  def how_workers_did_on_snippet
    @snippet = Snippet.find(params[:id])
    @word = @snippet.word
    @disambiguations = @snippet.disambiguations
    @senses = @word.senseeval_inventories
    @num_correct = @disambiguations.select{|d| d.senseeval_inventory_id == @snippet.senseeval_inventory_id}.length
  end

end
