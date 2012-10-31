source 'http://rubygems.org'

gem 'rails', '3.1'

gem 'rake', '0.9.2.2'
gem 'nokogiri', '1.5.0'
#gem "exception_notification", :git => "git://github.com/rails/exception_notification.git", :require => "exception_notifier"
gem 'crypt19', :platform => :ruby
gem 'rturk'
gem 'rak'
gem 'POpen4'
gem 'rails_admin', :git => 'git://github.com/sferik/rails_admin.git'
gem 'devise'
gem 'carrierwave'
#gem 'yui-compressor'
#gem 'jammit'
gem 'rubystats'

group :production do
  gem 'mysql2', :git => 'git://github.com/brianmario/mysql2.git'
end

group :development do
  gem 'mysql'
  gem 'win32-open3-19', :platforms => :mingw
  #handy tools to make the console and logging pretty
  gem 'win32console'
  gem 'hirb'
  gem 'wirble'
  gem 'awesome_print'
end

#### bundle install --without production