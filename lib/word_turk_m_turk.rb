module WordTurkMTurk
  include RTurkWrapper

  WordTurkMTurkVersion = "0.1a"
  #hit defaults
  EXPERIMENTAL_WAGE = 0.01
  DefaultBonus = 0.01 #in USD
  EXPERIMENTAL_COUNTRY = 'US'
  DEFAULT_HIT_TITLE = "Tell us the best meaning of a word... do many and earn a lot! Really Easy!!"
  DEFAULT_HIT_DESCRIPTION = %Q|Help us understand how language is used by identifying the correct definition of a target word. You will read a paragraph and tell us the best meaning of a given word|
  DEFAULT_HIT_KEYWORDS = "survey, questionnaire, poll, opinion, study, experiment"
  #time related HIT defualts
  DEFAULT_ASSIGNMENT_DURATION = 60 * 7 # 7min
  DEFAULT_HIT_LIFETIME = 60 * 55 # 55 min since cron jobs (not specified here) run every one hour
  DEFAULT_ASSIGNMENT_AUTO_APPROVAL = 60 * 60 * 24 * 1 # 1d
  DEFAULT_FRAME_HEIGHT = 800

  def mturk_create_wordturk_run_hit(run_id, options = {})
    options[:title] ||= DEFAULT_HIT_TITLE
    options[:description] ||= DEFAULT_HIT_DESCRIPTION
    options[:keywords] ||= DEFAULT_HIT_KEYWORDS
    options[:assignment_duration] ||= DEFAULT_ASSIGNMENT_DURATION
    options[:lifetime] ||= DEFAULT_HIT_LIFETIME
    options[:assignment_auto_approval] ||= DEFAULT_ASSIGNMENT_AUTO_APPROVAL
    options[:frame_height] ||= DEFAULT_FRAME_HEIGHT
    #stuff that's more likely to change
    options[:country] = EXPERIMENTAL_COUNTRY
    options[:wage] = EXPERIMENTAL_WAGE
    #for the actual url that hits our server (do not touch)
    options[:render_url] = "/#{PersonalInformation::ExperimentalController}?id=#{run_id}"
    #create the hit and return its data
    mturk_create_hit(options)
  end
end