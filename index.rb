#   Requires
#----------------------------------------------------------------------------

require 'rubygems'
require 'bundler'
Bundler.require
require './helpers'

#   DB Setup
#----------------------------------------------------------------------------

DataMapper.setup(:default, ENV['DATABASE_URL'] || 'mysql://root@localhost/itpresidents')

#   Classes
#----------------------------------------------------------------------------

class Choice

  include DataMapper::Resource

  property :id,         Serial    
  property :name,       String
  property :tables,     String  # comma separated string of table choices, ranking 1-9
  property :choice,     Integer
  
  def tables_array
    self.tables.split(",")
  end
  
  def choice_num
    tables_array.find_index { |t| t.to_i == choice } + 1
  end
  
  def choice_unique?(num)
    Choice.all(:name.not => name).all? { |r| tables_array[num] != r.tables_array[num] }
  end
  
  def next_available
    tables_array.find_index { |t| Choice.table_available?(t) }
  end
  
  def self.assign_next
    if not Choice.first(:choice => nil).nil?
      lowest_choice = Choice.all(:choice => nil).map { |r| r.next_available }.min
      lowest_residents = Choice.all(:choice => nil).find_all { |r| 
        r.next_available == lowest_choice 
      }
      r = lowest_residents.sort_by { rand }[0]
      r.choice = r.tables_array[r.next_available]
      r.save
      self.assign_next
    end
  end
  
  def self.table_available?(table_num)
    Choice.first(:choice => table_num).nil?
  end
  
  def self.names
    [
      "Brett",
      "Chika",
      "Calli",
      "Greg",
      "Molly",
      "Patrick",
      "Patricia",
      "Rune",
      "Zeven"
    ]
  end
  
  def self.assign_uniques(num)
    self.all.select { |r| 
      if r.choice_unique?(num)
        r.choice = r.tables_array[num]
        r.save
        false
      else
        true
      end
    }
  end
  
end

#DataMapper.auto_migrate!

#   Routes
#----------------------------------------------------------------------------

get '/' do
  erb :choose
end

post '/choices' do
  resident = Choice.first_or_create(:name => params[:name])
  resident.tables = params[:tables].join(",")
  resident.save
end

get '/decide' do
  
  # first clear
  Choice.all.each do |r|
    r.choice= nil
    r.save
  end
  
  Choice.assign_uniques(0)
  Choice.assign_next
  @residents = Choice.all
  erb :decide
end

get '/fakedata/create' do 
  
  choices = [ 
              "4,3,2,5,1,8,6,9,7",
              "4,3,1,8,5,7,9,6,2",
              "4,9,8,7,6,5,3,2,1",
              "1,2,3,4,5,6,7,8,9",
              "1,2,3,4,5,6,7,8,9",
              "2,3,4,5,6,7,8,9,1",
              "3,4,5,6,7,8,9,2,1",
              "1,9,7,8,6,5,4,3,2",
              "8,7,6,5,4,3,2,1,9"
            ]
            
  Choice.names.each_with_index do |name, i|
    resident = Choice.first_or_create(:name => name)
    resident.tables = choices[i]
    resident.save
  end
end

get '/fakedata/destroy' do
  Choice.destroy
end

