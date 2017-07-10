class Entrant
  include Mongoid::Document
  include Mongoid::Timestamps
  Mongo::Logger.logger.level = ::Logger::INFO

  store_in collection: "results"

  embeds_many :results, class_name: 'LegResult', order: [:"event.o".asc]
  embeds_one :race, class_name: 'RaceRef', autobuild: true
  embeds_one :racer, as: :parent, class_name: 'RacerInfo', autobuild: true

  field :bid, as: :bib, type: Integer
  field :secs, as: :secs, type: Float
  field :o, as: :overall, type: Placing
  field :gender, as: :gender, type: Placing
  field :group, as: :group, type: Placing

  def update_total result
    self.secs = 0
    results.each do |t|
      self.secs = self.secs + t.secs if !t.secs.nil?
    end
  end

  def the_race
    race.race
  end
  
end
