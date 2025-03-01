class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index # For rate ranking purpose
    @all_ratings = Movie.ratings
    @sort = params[:sort]|| session[:sort]
    session[:ratings] = session[:ratings] || {'G' => '','PG' => '','PG13' => '','R' => ''}
    @t_param = params[:ratings]|| session[:ratings]
    session[:sort] = @sort
    session[:ratings] = @t_param
    @movies = Movie.where(rating: session[:ratings].keys).order(session[:sort])
    if (params[:sort].nil? and !(session[:sort].nil?)) or  (params[:ratings].nil? and !(session[:ratings].nil?))
      flash.keep
      redirect_to movies_path(sort: session[:sort],ratings:session[:ratings])
    end
  end

  def new
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
