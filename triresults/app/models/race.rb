class Race
  include Mongoid::Document
  include Mongoid::Timestamps
  Mongo::Logger.logger.level = ::Logger::INFO

  field :n, as: :name, type: String
  field :date, as: :date, type: Date
  field :loc, as: :location, type: Address

  embeds_many :events, as: :parent, order: [:order.asc]

  scope :upcoming, -> { where(:date.gte => Date.current) }
  scope :past, -> { where(:date.lt => Date.current) }

end