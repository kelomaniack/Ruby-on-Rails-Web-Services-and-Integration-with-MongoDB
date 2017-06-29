class Place

  # convenience method for access to client in console
  def self.mongo_client
    Mongoid::Clients.default
  end

  # convenience method for access to zips collection
  def self.collection
    self.mongo_client['places']
  end

  # reads the contents of the file and inserts into GridFS along
  # with some optional metadata. The :_id of the file is returned.
  def self.load_all file
    input = {}
    input = JSON.parse(file.read)
    collection.insert_many(input)
  end

end
