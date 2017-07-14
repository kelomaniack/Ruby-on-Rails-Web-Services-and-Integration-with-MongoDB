module Api
  class RacesController < ApplicationController

    rescue_from ActionView::MissingTemplate do |exception|
      Rails.logger.debug("Accept:#{request.accept}")
      render plain: "woops: we do not support that content-type[#{request.accept}]", status: :unsupported_media_type
    end

    rescue_from Mongoid::Errors::DocumentNotFound do |exception|
      @msg = "woops: cannot find race[#{params[:id]}]"
      if !request.accept || request.accept == "*/*"
        render plain: @msg, status: :not_found
      else
        case request.accept
          when "application/json" then render json: {"msg" => @msg}, status: :not_found, template: "api/error_msg"
          else
            render status: :not_found, template: "api/error_msg"
        end
        Rails.logger.debug("Accept:#{request.accept}")
      end
    end

    # GET /races
    # GET /races.json
    def index
      if !request.accept || request.accept == "*/*"
        render plain: "#{api_races_path}, offset=[#{params[:offset]}], limit=[#{params[:limit]}]"
      end
    end

    # GET /races/1
    # GET /races/1.json
    def show
      if !request.accept || request.accept == "*/*"
        render plain: api_race_path(params[:id])
      else
        set_race
        render "show", status: :ok
      end
    end

    # GET /races/new
    def new
      @race = Race.new
    end

    # GET /races/1/edit
    def edit
    end

    # POST /races
    # POST /races.json
    def create
      Rails.logger.debug("Accept:#{request.accept}")
      if !request.accept || request.accept == "*/*"
        if params && params[:race] && params[:race][:name]
          render plain: "#{params[:race][:name]}", status: :ok
        else
          render plain: :nothing, status: :ok
        end
      elsif !request.accept || request.accept != "*/*"
        race = Race.new(race_params)
        if race.save
          render plain: "#{params[:race][:name]}", status: :created
        else
          render plain: "#{params[:race][:name]}", status: :error
        end
      else
        render plain: ""
      end
    end

    # PATCH/PUT /races/1
    # PATCH/PUT /races/1.json
    def update
      respond_to do |format|
        if @race.update(race_params)
          format.html { redirect_to @race, notice: 'Race was successfully updated.' }
          format.json { render :show, status: :ok, location: @race }
        else
          format.html { render :edit }
          format.json { render json: @race.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /races/1
    # DELETE /races/1.json
    def destroy
      @race.destroy
      respond_to do |format|
        format.html { redirect_to races_url, notice: 'Race was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_race
      @race = Race.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def race_params
      params.require(:race).permit(:name, :date, :city, :state, :swim_distance, :swim_units, :bike_distance, :bike_units, :run_distance, :run_units)
    end
  end
end