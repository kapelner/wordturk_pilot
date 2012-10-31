# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Wordturkers::Application.initialize!

ActionMailer::Base.smtp_settings = {
  :address => "smtp.sendgrid.net",
  :port => 25,
  :domain => "wordturk_experiment.com",
  :authentication => :plain,
  :user_name => "your sendgrid user name",
  :password => "your sendgrid password"
}