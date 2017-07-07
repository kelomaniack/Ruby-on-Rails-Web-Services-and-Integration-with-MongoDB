class Point
  attr_accessor :longitude, :latitude

  #creates a DB-form of the instance
  def to_hash
    params = {}
    params[:type] = "Point"
    params[:coordinates] = [@longitude, @latitude]
    return params
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
