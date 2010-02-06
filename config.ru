require 'toto'

# Rack config
use Rack::Static, :urls => ['/css', '/js', '/images', '/favicon.ico'], :root => 'public'
use Rack::ShowExceptions
use Rack::CommonLogger

# Run application
toto = Toto::Server.new do
  #
  # Add your settings here
  # set [:setting], [value]
  #
  set :title, 'tlog'
  set :url, 'http://quiet-night-71.heroku.com/'
  set :date, lambda {|now| now.strftime("%B #{now.day.ordinal} %Y") }
end

run toto

