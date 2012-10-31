class DataDumpController < ApplicationController

  def disambiguations
    #only dump the data that is completed
    response.headers['Cache-Control'] = 'max-age=30, must-revalidate'
    send_file DataDump.dump_disambiguations(Disambiguation.assign_batches(Disambiguation.completed)),
      :type => 'text/plain', :disposition => 'attachment'
  end

  def snippet_texts
    #only dump the data that is completed
    response.headers['Cache-Control'] = 'max-age=30, must-revalidate'
    send_file DataDump.dump_snippets(Snippet.experimentals.includes(:word)),
      :type => 'text/plain', :disposition => 'attachment'
  end

  def senses
    #only dump the data that is completed
    response.headers['Cache-Control'] = 'max-age=30, must-revalidate'
    send_file DataDump.dump_senses(Snippet.unique_experimental_senses),
      :type => 'text/plain', :disposition => 'attachment'
  end
end
