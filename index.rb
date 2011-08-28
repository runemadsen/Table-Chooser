#   Requires
#----------------------------------------------------------------------------

require 'rubygems'
require 'bundler'
Bundler.require
require 'helpers.rb'

#   DB Setup
#----------------------------------------------------------------------------

DataMapper.setup(:default, ENV['DATABASE_URL'] || 'mysql://root@localhost/table_chooser')

#   Classes
#----------------------------------------------------------------------------

class Choice

  include DataMapper::Resource

  property :id,         Serial    
  property :name,       String    
  property :tables,     String  # comma separated string of table choices, ranking 1-9
  property :choice,     Integer
  
end

#DataMapper.auto_migrate!

#   Routes
#----------------------------------------------------------------------------


get '/' do
  erb :choose
end