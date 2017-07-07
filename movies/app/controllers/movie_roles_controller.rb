class MovieRolesController < ApplicationController
  before_action :set_movie
  before_action :set_movie_role, only: [:show, :edit, :update, :destroy]

  # GET /movie_roles
  # GET /movie_roles.json
  def index
    @movie_roles = @movie.roles
  end

  # GET /movie_roles/1
  # GET /movie_roles/1.json
  def show
  end

  # GET /movie_roles/new
  def new
    @movie_role = MovieRole.new
  end

  # GET /movie_roles/1/edit
  def edit
  end

  # POST /movie_roles
  # POST /movie_roles.json
  def create
    @movie_role = MovieRole.new(movie_role_params)

    respond_to do |format|
      if @movie_role.save
        format.html { redirect_to @movie_role, notice: 'Movie role was successfully created.' }
        format.json { render :show, status: :created, location: @movie_role }
      else
        format.html { render :new }
        format.json { render json: @movie_role.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /movie_roles/1
  # PATCH/PUT /movie_roles/1.json
  def update
    respond_to do |format|
      if @movie_role.update(movie_role_params)
        format.html { redirect_to @movie_role, notice: 'Movie role was successfully updated.' }
        format.json { render :show, status: :ok, location: @movie_role }
      else
        format.html { render :edit }
        format.json { render json: @movie_role.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movie_roles/1
  # DELETE /movie_roles/1.json
  def destroy
    @movie_role.destroy
    respond_to do |format|
      format.html { redirect_to movie_roles_url, notice: 'Movie role was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_movie_role
    @movie_role = @movie.roles.find_by(:id=>params[:id])
  end

  def set_movie
    @movie = Movie.find(params[:movie_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def movie_role_params
    params.require(:movie_role).permit(:character, :actor_id)
  end
end
