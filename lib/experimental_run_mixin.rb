module ExperimentalRunMixin

  attr_accessor :batch
  
  KapChaWordsPerMinute = 300
  UseKapchaDiscourageNavigation = true

  def redirect_address
    {:action => :index, :id => self.id, :workerId => self.mturk_worker_id, :assignmentId => self.mturk_assignment_id}
  end
  
  def has_duplicate_questions?
    false
  end

  def rejected?
    !self.rejected_at.nil?
  end

  def send_bonus!(amt)
    mturk_bonus_assignment(self.mturk_assignment_id, self.mturk_worker_id, amt)
    self.update_attributes(:bonus => amt)
  end

  def send_payment_and_dispose!
    mturk_approve_assignment(self.mturk_assignment_id) #it won't get marked as paid if this crashese
    self.update_attributes(:paid_at => Time.now)
    dispose_hit_on_mturk(self.mturk_hit_id) #we can also delete it on mturk, tidy up
  end

  def paid?
    !self.paid_at.nil?
  end

  def submitted?
    !self.finished_at.nil?
  end

  def time_spent
    return nil if self.finished_at.nil?
    self.finished_at - self.started_at
  end

  def time_to_read_consent
    return nil if self.read_consent_at.nil?
    self.read_consent_at - self.started_at
  end

  DefaultBonus = 0
  def default_bonus
    DefaultBonus
  end

  def pay_status_to_s
    if self.paid?
      %Q|<span style="color:green;">#{self.bonus.nil? ? "paid" : "bonus (#{self.bonus})"}</span>|
    elsif self.rejected?
      %Q|<span style="color:red;">rej</span>|
    end
  end

  def expired?
    Time.now > self.to_be_expired_at
  end

  def expired_and_uncompleted?
    self.expired? and !self.completed?
  end

  def started?
    self.started_at.nil? ? false : true
  end
  
  def expired_and_unstarted?
    self.expired? and self.did_not_read_directions_yet?
  end

  def did_not_read_directions_yet?
    self.read_directions_at.nil?
  end

  def comments_word_count
    self.comments.split(/\s/).length
  end

  #CLASS METHODS
  module ClassMethods

    def pay_those_unpaid!
      self.all.select{|run| run.completed? and !run.paid?}.each do |run|
        begin
          run.send_payment_and_dispose!
        rescue
          p "couldn't pay disambiguation #{run.id}"
        end
      end
    end

    def all_current_experimental_version
      self.where("version <= ?", PersonalInformation::CURRENT_EXPERIMENTAL_VERSION_NO).includes(PersonalInformation::ExperimentalModel::ModelsToLoadWithEachRun)
    end

    def create_hitsets_and_post(n)
      n.times{self.create_a_hit_and_post}
    end

    #convenience method for creating HIT(s)
    def create_a_hit_and_post
      run = Disambiguation.new
      #standard stuff
      run.version = PersonalInformation::CURRENT_EXPERIMENTAL_VERSION_NO
      run.wage = WordTurkMTurk::EXPERIMENTAL_WAGE
      run.country = WordTurkMTurk::EXPERIMENTAL_COUNTRY
      run.to_be_expired_at = WordTurkMTurk::DEFAULT_HIT_LIFETIME.seconds.from_now
      run.initialize_new_run #to be implemented in the model itself
      run.save!
      mturk_hit = mturk_create_wordturk_run_hit(run.id)
      run.mturk_hit_id = mturk_hit.hit_id
      run.mturk_group_id = mturk_hit.type_id
      run.save!
      run
    end

    def all_current_experimental_version_completed
      all = self.all_current_experimental_version.select{|run| run.completed?}
      self.assign_batches(all)
    end

    def all_current_experimental_version_with_abandons
      all = self.all_current_experimental_version.reject{|run| run.has_duplicate_questions?}
      self.assign_batches(all)
    end

    TimeBetweenBatches = 10.minutes #the cron job does not take more than 10 min to create any number of HITs
    def assign_batches(runs = self.all)
      current_batch = 1
      #sort by when it was created
      runs = runs.sort{|a, b| a.created_at <=> b.created_at}
      runs.each_with_index do |s, i|
        if i > 0 and s.created_at - runs[i - 1].created_at > TimeBetweenBatches
          current_batch += 1
        end
        s.batch = current_batch
      end
    end

    def cleanup_mturk!
      self.all.inject(0) do |num_cleaned, run|
        if run.expired? and !run.paid? and !run.rejected?
          begin
            p dispose_hit_on_mturk(run.mturk_hit_id)
            num_cleaned += 1
          rescue => e
            p e
          end
        end
        num_cleaned
      end
    end

    def delete_all_hits_from_mturk!
      self.all.each do |run|
        begin
          p dispose_hit_on_mturk(run.mturk_hit_id)
          p delete_hit_on_mturk(run.mturk_hit_id)
        rescue #don't do anything, who cares
        end
      end
    end
  end

  def self.included(base)
    base.extend(ClassMethods)
  end
end
