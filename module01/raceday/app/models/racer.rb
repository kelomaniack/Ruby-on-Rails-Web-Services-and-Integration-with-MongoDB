class Racer
  include ActiveModel::Model

  attr_accessor :id, :number, :first_name, :last_name, :gender, :group, :secs

  def initialize(params={})
    @id = params[:_id].nil? ? params[:id] : params[:_id].to_s
    @number=params[:number].to_i
    @first_name=params[:first_name]
    @last_name=params[:last_name]
    @gender=params[:gender]
    @group=params[:group]
    @secs=params[:secs].to_i
  end

  # tell Rails whether this instance is persisted
  def persisted?
    !@id.nil?
  end

  def created_at
    nil
  end

  def updated_at
    nil
  end

  # convenience method for access to client in console
  def self.mongo_client
    Mongoid::Clients.default
  end

  # convenience method for access to zips collection
  def self.collection
    self.mongo_client['racers']
  end

  # implement a find that returns a collection of document as hashes.
  # Use initialize(hash) to express individual documents as a class
  # instance.
  #   * prototype - query example for value equality
  #   * sort - hash expressing multi-term sort order
  #   * skip - optional skip to skip results
  #   * limit - number of documents to include
  def self.all(prototype={}, sort={:number => 1}, skip=0, limit=nil)
    Rails.logger.debug { "getting all racers, prototype=#{prototype}, sort=#{sort}, skip=#{skip}, limit=#{limit}" }

    result=collection.find(prototype)
               .sort(sort)
               .skip(skip)
    result=result.limit(limit) if !limit.nil?

    return result
  end

  # locate a specific document. Use initialize(hash) on the result to
  # get in class instance form
  def self.find id
    id = BSON::ObjectId(id) if id.is_a?(String)
    Rails.logger.debug { "getting racer #{id}" }
    result = collection.find(_id: id).first
    return result.nil? ? nil : Racer.new(result)
  end

  # create a new document using the current instance
  def save
    Rails.logger.debug { "saving #{self}" }

    result=self.class.collection
               .insert_one(_id: @id, number: @number, first_name: @first_name, last_name: @last_name, gender: @gender, group: @group, secs: @secs)
    @id=result.inserted_id.to_s
  end

  def update(params)
    @number = params[:number].to_i
    @first_name = params[:first_name]
    @last_name = params[:last_name]
    @gender = params[:gender]
    @group = params[:group]
    @secs = params[:secs].to_i

    @BSON_id = BSON::ObjectId(@id)

    params.slice!(:number, :first_name, :last_name, :gender, :group, :secs) if !params.nil?
    self.class.collection.find(_id: @BSON_id).update_one(:$set => {number: @number, first_name: @first_name, last_name: @last_name,
                                                                   gender: @gender, group: @group, secs: @secs})
  end

  # remove the document associated with this instance form the DB
  def destroy
    Rails.logger.debug {"destroying #{self}"}

    self.class.collection.find(number: @number).delete_one

  end

  #implememts the will_paginate paginate method that accepts
  # page - number >= 1 expressing offset in pages
  # per_page - row limit within a single page
  # also take in some custom parameters like
  # sort - order criteria for document
  # (terms) - used as a prototype for selection
  # This method uses the all() method as its implementation
  # and returns instantiated Zip classes within a will_paginate
  # page
  def self.paginate(params)
    Rails.logger.debug("paginate(#{params})")
    page=(params[:page] ||= 1).to_i
    limit=(params[:per_page] ||= 30).to_i
    offset=(page-1)*limit
    sort=params[:sort] ||= {number: 1}

    #get the associated page of Racers -- eagerly convert doc to Racer
    racers=[]
    all({}, sort, offset, limit).each do |doc|
      racers << Racer.new(doc)
    end

    #get a count of all documents in the collection
    total=all({}, sort, 0, 1).count

    WillPaginate::Collection.create(page, limit, total) do |pager|
      pager.replace(racers)
    end
  end

end