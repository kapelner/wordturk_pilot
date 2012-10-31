class DisambiguatorController < ApplicationController
  layout 'disambiguation'
  helper 'surveyor'

  def index
    @dr = Disambiguation.find(params[:id])

    #if the survey is completed, shoo them away
    if @dr.completed?
      #record the finishing time only once
      redirect_to :action => :run_completed, :id => @dr.id
      return
    end

    @preview = params[:assignmentId] == RTurkWrapper::PreviewAssignmentId
    if !@dr.mturk_worker_id.nil?
      #we need to move them away
      redirect_to :action => :wrong_user
      return
    elsif @preview
      redirect_to :action => :splash_page
    #if it's not a preview, MTurk needs to send us the two magic parameters, if not, throw an error
    elsif params[:workerId].blank? or params[:assignmentId].blank?
      redirect_to :action => :error
      
    #we're good to go at this point
    else
      #record the beginning time only once
      @dr.update_attributes(:started_at => Time.now) if @dr.started_at.nil?

      #load up all this workers' HITs, will be useful
      @worker_hits = Disambiguation.find_all_by_mturk_worker_id(params[:workerId])
      
      #check if they've done this snippet previously
      if @worker_hits.reject{|dr| dr == @dr}.detect{|dr| dr.snippet_id == @dr.snippet_id}
        redirect_to :action => :did_this_snippet_previously
        return
      end

      #set the worker only if the worker wasn't set previously
      @dr.update_attributes(:mturk_worker_id => params[:workerId]) if @dr.mturk_worker_id.nil?
      #check for different worker than expected
      if @dr.mturk_worker_id != params[:workerId]
        #we need to move them away
        redirect_to :action => :wrong_user
        return
      end
      #always set the assignment!!! This gets around that dumb MTurk bug... and do the ip address as well
      @dr.update_attributes(:mturk_assignment_id => params[:assignmentId], :ip_address => request.remote_ip)

      #now we need to check if they viewed the consent form
      if @worker_hits.select{|dr| dr.read_consent_at}.empty?
        render :action => :consent_form
        return
      end

      #now run experiment... the data that needs to be loaded can be taken care of in the view
      @snippet = @dr.snippet
      @word = @snippet.senseeval_inventory.word
      @senses = @word.senseeval_inventories.sort_by{rand}
      
    end
  end

  def keyboard_error
    KeyboardError.create(:disambiguation_id => params[:id])
    render :nothing => true
  end

  def record_focus_or_unfocus
    BrowserStatus.create(:disambiguation_id => params[:id], :status => params[:status])
    render :nothing => true
  end

  def submit_sense_and_optional_feedback
    dr = Disambiguation.find(params[:id])
    dr.comments = params[:comments]
    dr.senseeval_inventory_id = params[:choice]
    dr.finished_at = Time.now
    dr.save!
    redirect_to :action => :run_completed, :id => dr.id
  end

  def run_completed
    @dr = Disambiguation.find(params[:id])
  end

  def agreed_to_consent
    return unless request.post?
    dr = Disambiguation.find(params[:id])
    raise "already agreed to consent" if dr.read_consent_at
    dr.update_attributes(:read_consent_at => Time.now, :age => params[:age].to_i, :gender => params[:gender])
    redirect_to dr.redirect_address
  end

  def read_directions
    return unless request.post?
    dr = Disambiguation.find(params[:id])
    raise "already read directions" if dr.read_directions_at
    dr.update_attributes(:read_directions_at => Time.now)
    redirect_to dr.redirect_address
  end
end
