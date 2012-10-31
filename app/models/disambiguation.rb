class Disambiguation < ActiveRecord::Base
  include ExperimentalRunMixin
  extend WordTurkMTurk
  include WordTurkMTurk
  
  belongs_to :snippet
  belongs_to :senseeval_inventory #if this is present, the worker has answered
  has_many :browser_statuses

  validates :version, :presence => true
  validates :wage, :presence => true
  validates :country, :presence => true
  validates :to_be_expired_at, :presence => true

  scope :unmarked, where(:senseeval_inventory_id => nil)
  scope :completed, where("senseeval_inventory_id IS NOT NULL")

  ModelsToLoadWithEachRun = []

  def initialize_new_run
    #do nothing
  end

  def completed?
    !self.senseeval_inventory_id.nil?
  end

  #pretty simple: does their response match the snippet's correct sense?
  def correct?
    self.snippet.senseeval_inventory_id == self.senseeval_inventory_id
  end
  
  #if we ever want to do experiments with different treatments...
  RandomizedTreatments = []
  TreatmentNames = {}

  def treatment_to_s
    TreatmentNames[self.treatment]
  end

  def Disambiguation.unmarked_and_expired
    Disambiguation.unmarked.select{|d| d.expired?}
  end
  
  NUM_DISAMBIGUATIONS_PER_SNIPPET = 10
  NUM_HITS_TO_CREATE_PER_BATCH = Rails.env.development? ? 5 : 750
  def Disambiguation.create_hitset_with_words_and_post!
    #delete disambiguations with no marking
    Disambiguation.unmarked_and_expired.each{|d| d.delete}

    #now we get a list snippets that need to be done for the experiment to be complete
    exp_snippet_ids = []
    Snippet.experimentals.each do |s|
      s.num_disambiguations_left.times{exp_snippet_ids << s.id}
    end
    #now randomize and sample NUM_HITS_TO_CREATE_PER_BATCH of them
    exp_snippet_ids = exp_snippet_ids.sort_by{rand}.slice(0, NUM_HITS_TO_CREATE_PER_BATCH)
    #now we actually create the HITs, we don't create any if we're done with the experiment
    exp_snippet_ids.each do |s_id|
      run = create_a_hit_and_post
      run.update_attributes(:snippet_id => s_id)
    end    
  end

  def age_and_gender_str
    d = all_worker_disambiguations.detect{|d| !d.age.nil? or !d.gender.nil?}
    d.nil? ? "" : "#{d.age} / #{d.gender}"
  end

  def all_worker_disambiguations
    Disambiguation.where(:mturk_worker_id => self.mturk_worker_id)
  end

  def num_worker_disambiguations
    all_worker_disambiguations.length
  end

  def how_good_is_worker_as_pct
    ds = all_worker_disambiguations
    ds.select{|d| d.correct?}.length / ds.length.to_f * 100
  end

  def Disambiguation.num_snippets_left_in_experiment
    Snippet.experimentals.map{|s| s.num_disambiguations_left}.sum
  end
end

#http://mechanicalturk.typepad.com/blog/2011/04/overview-lifecycle-of-a-hit-.html

=begin
CRON JOB CODE:
cd /data/wordturk2/current && bundle exec rails runner -e production 'Disambiguation.create_hitset_with_words_and_post!'
=end
