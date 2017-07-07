class Entrant
  include Mongoid::Document
  include Mongoid::Timestamps
  Mongo::Logger.logger.level = ::Logger::INFO

  store_in collection: "results"

  field :bid, as: :bib, type: Integer
  field :secs, as: :secs, type: Float
  field :o, as: :overall, type: Placing
  field :gender, as: :gender, type: Placing
  field :group, as: :group, type: Placing
end
