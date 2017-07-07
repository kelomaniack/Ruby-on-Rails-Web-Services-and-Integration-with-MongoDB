class Event
  include Mongoid::Document
  field :o, as: :order, type: Integer
  field :n, as: :name, type: String
  field :d, as: :distance, type: Float
  field :u, as: :units, type: String

  embedded_in :parent, polymorphic: true, touch: true

  validates_presence_of :order
  validates_presence_of :name

  def meters
    case units
      when "kilometers" then return distance * 1000
      when "yards" then return distance * 0.9144
      when "miles" then return distance * 1609.344
      when "meters" then return distance
    end
  end

  def miles
    case units
      when "kilometers" then return distance * 0.621371
      when "yards" then return distance * 0.000568182
      when "miles" then return distance
      when "meters" then return distance * 0.00062137
    end
  end
end
