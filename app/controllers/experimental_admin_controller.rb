class ExperimentalAdminController < ApplicationController
  include RTurkWrapper
  
  before_filter :admin_required

  ##### investigate all runs

  MAX_RUNS_TO_DISPLAY = 1000
  def main_console
    @title = 'Administrator Portal'
    @version_info = VersionInfo.find(PersonalInformation::CURRENT_EXPERIMENTAL_VERSION_NO)
    @runs = PersonalInformation::ExperimentalModel.all_current_experimental_version
    @runs = @runs.reject{|s| s.expired? && !s.completed?} unless params[:rejected]
    @runs = @runs.select{|s| s.completed?} if params[:completed]
    params[:num_runs] ||= MAX_RUNS_TO_DISPLAY
    @runs = @runs.slice(0...params[:num_runs].to_i)
  end

  def completed_hits
    @title = 'Completed HITs'
    @runs_completed = PersonalInformation::ExperimentalModel.all_current_experimental_version_completed
  end

  def comments_page
    @title = 'All Comments'
    @runs = PersonalInformation::ExperimentalModel.all_current_experimental_version_completed
    @runs = @runs.reject{|r| r.comments.blank?} if params[:only_comments]
  end

  def investigate_attrition
    @title = 'Deserted HITs'
    @runs = PersonalInformation::ExperimentalModel.all.select{|r| r.expired_and_uncompleted?}.reject{|r| r.did_not_read_directions_yet?}
    @runs = @runs.select{|br| br.treatment == params[:treatment].to_i} if params[:treatment]
  end

  def dashboard
    @title = 'Dashboard'
    @runs_completed = PersonalInformation::ExperimentalModel.all_current_experimental_version_completed
    #kill those that are completed and then kill those that were never started
    @runs_completed = PersonalInformation::ExperimentalModel.all_current_experimental_version_with_abandons.reject{|r| @runs_completed.include?(r)}.reject{|r| r.did_not_read_directions_yet?}
  end

  def delete_run
    PersonalInformation::ExperimentalModel.find(params[:id]).delete
    redirect_to :action => :index
  end

  #### investigate one run

  def investigate_run
    @br = PersonalInformation::ExperimentalModel.find(params[:id], :include => PersonalInformation::ExperimentalModel::ModelsToLoadWithEachRun)
    @bbts = BigBrotherTrack.find_all_by_mturk_worker_id(@br.mturk_worker_id, :include => :big_brother_params)
  end

  #### mturk functions create hits, pay, bonus, reject, email workers, cleanup

  def create_hits
    PersonalInformation::ExperimentalModel.create_hitsets_and_post(params[:n].to_i)
    redirect_to :action => :index
  end

  def pay
    run = PersonalInformation::ExperimentalModel.find(params[:id])
    #all checks for valid bonus from javascript
    if params[:bonus] and !params[:bonus].strip.blank? and params[:bonus].strip != 'NaN' and params[:bonus].to_f > 0
      run.send_bonus!(params[:bonus])
    end
    run.send_payment_and_dispose!
    render :text => run.pay_status_to_s
  end

  def reject
    run = PersonalInformation::ExperimentalModel.find(params[:id])
    mturk_reject_assignment(run.mturk_assignment_id)
    run.update_attributes(:rejected_at => Time.now)
    dispose_hit_on_mturk(run.mturk_hit_id) #we can also delete it on mturk, tidy up
    render :text => run.pay_status_to_s
  end

  def send_emails_to_workers
    workers = params[:worker_ids].split(',')
    bad_ids = []
    workers.each do |w|
      begin
        mturk_send_emails(params[:subject], params[:body] + "\r\n\r\nWorker: " + w, [w])
      rescue
        bad_ids << w
      end
    end
    render :text => "#{workers.length - bad_ids.length} email(s) sent! #{bad_ids.empty? ? '' : 'Errors: ' + bad_ids.join(', ')}"
  end

  def cleanup_mturk
    flash[:notice] = "Cleaned up #{PersonalInformation::ExperimentalModel.cleanup_mturk} HIT(s) from MTurk"
    redirect_to :action => :index
  end


  #### dev stuff

  def nuke
    if Rails.env.development?
      PersonalInformation::ExperimentalModel.destroy_all
      BigBrotherTrack.destroy_all
      BigBrotherParam.destroy_all
      NewsArticle.destroy_all
      Snippet.destroy_all
      Word.destroy_all
      SenseevalInventory.destroy_all
      VersionInfo.destroy_all
    else
      flash[:error] = 'You cannot nuke the db on production'
    end
    redirect_to :action => :index
  end

  def rebuild_db
    if Rails.env.development?
      #first kill the db
      Word.destroy_all
      SenseevalInventory.destroy_all
      Snippet.destroy_all
      #now rebuild part of it except the snippets
      Word.load_words_from_senseval_data!
      SenseevalInventory.create_all_from_word_data_files!
      flash[:notice] = %Q|Data rebuilt but you still need to Snippet.create_all_from_data! from the console|
    else
      flash[:error] = 'You cannot rebuild the db on production'
    end
    redirect_to :action => :index
  end
  

  #add your test worker IDs here
  DEV_WORKERS = []
  def nuke_dev_workers
    dev_workers = PersonalInformation::ExperimentalModel.find_all_by_mturk_worker_id(DEV_WORKERS).each{|s| s.destroy}
    flash[:notice] = "nuked #{dev_workers.length} dev worker(s)"
    redirect_to :action => :index
  end

  ############# Version info stuff

  def versions
    @title = 'Version Information'
    @version_infos = VersionInfo.find(:all)
  end

  def update_version_description
    VersionInfo.find(params[:version]).update_attributes(:description => params[:description])
    render :nothing => true #ajax
  end

  def create_new_version_info
    VersionInfo.create(:version => VersionInfo.count + 1)
    redirect_to :action => :versions
  end

  ################ Investigate an individual run

  def update_run_notes
    PersonalInformation::ExperimentalModel.find(params[:id]).update_attributes(:notes => params[:notes])
    render :nothing => true #ajax
  end

  #### admin logout
  
  def logout
    admin_logout
    redirect_to '/'
  end
  

end
