require 'pp'
require 'mongo'
Mongo::Logger.logger.level = ::Logger::DEBUG

class Solution
  @@db = nil
  
  #Implement a class method in the `Solution` class called `mongo_client` that will 
  def self.mongo_client
    @@db = Mongo::Client.new('mongodb://localhost:27017/test')
  end

  #Implement a class method in the `Solution` class called `collection` that will
  def self.collection
    #return the `zips` collection
    self.mongo_client if not @@db
    @@db[:zips]
    
  end

  #Implement an instance method in the `Solution` class called `sample` that will
  def sample
    #return a single document from the `zips` collection from the database. 
    #This does not have to be random. It can be first, last, or any other document in the collection.
    #self.class.collection.find.first
    @@db[:zips].find.first
  end
end

#byebug
db=Solution.mongo_client
p db
zips=Solution.collection
p zips
s=Solution.new

pp "SAMPLE"
pp s.sample
