class Point
  attr_accessor :longitude, type: Integer
  attr_accessor :latitude, type: Integer

  #creates a DB-form of the instance
  def to_hash
    {:type => 'Point', :coordinates => [@longitude, @latitude]}
  end

  def initialize(params = {})

    if !params.nil?
      if params[:type]
        @longitude = params[:coordinates][0]
        @latitude = params[:coordinates][1]

      else
        @longitude = params[:lng]
        @latitude = params[:lat]
      end

    end
  end

end
