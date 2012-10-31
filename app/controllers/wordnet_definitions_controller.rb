class WordnetDefinitionsController < ApplicationController
  before_filter :admin_required

 
  # GET /wordnet_definitions
  # GET /wordnet_definitions.xml
  def index
    @wordnet_definitions = if params[:entry]
      Word.find_by_entry(params[:entry]).wordnet_definitions
    else
      WordnetDefinition.find(:all, :include => :word)
    end

    
  end

  # GET /wordnet_definitions/1
  # GET /wordnet_definitions/1.xml
  def show
    @wordnet_definition = WordnetDefinition


  end

  # GET /wordnet_definitions/new
  # GET /wordnet_definitions/new.xml
  def new
    @wordnet_definition = WordnetDefinition.new


  end

  # GET /wordnet_definitions/1/edit
  def edit
    @wordnet_definition = WordnetDefinition.find(params[:id])
  end

  # POST /wordnet_definitions
  # POST /wordnet_definitions.xml
  def create
    @wordnet_definition = WordnetDefinition.new(params[:wordnet_definition])

  end

  # PUT /wordnet_definitions/1
  # PUT /wordnet_definitions/1.xml
  def update
    @wordnet_definition = WordnetDefinition.find(params[:id])

  end

  # DELETE /wordnet_definitions/1
  # DELETE /wordnet_definitions/1.xml
  def destroy
    @wordnet_definition = WordnetDefinition.find(params[:id])
    @wordnet_definition.destroy

  end
end
