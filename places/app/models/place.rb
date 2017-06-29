class Place

  include ActiveModel::Model
  attr_accessor :id, :formatted_address, :location, :address_components

  def self.mongo_client
    Mongoid::Clients.default
  end

  def persisted?
    !@id.nil?
  end

  def self.collection
    self.mongo_client['places']
  end

  def self.load_all file
    input = {}
    input = JSON.parse(file.read)
    collection.insert_many(input)
  end

  def initialize(params = {})

    @id = params[:_id].nil? ? params[:id] : params[:_id].to_s
    @formatted_address = params[:formatted_address]
    @location = Point.new(params[:geometry][:geolocation]) if !params.nil?
    @address_components = params[:address_components].map { |a| AddressComponent.new(a) if !params[:address_components].nil? }
  end

  def self.find_by_short_name input
    Rails.logger.debug {"getting short_name #{input}"}

    collection.find(:'address_components.short_name'=>input)

  end

  def self.to_places collection
    collection.map{|doc| Place.new(doc)}
  end



















end
