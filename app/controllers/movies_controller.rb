class MoviesController < ApplicationController
  
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    # retrieve movie ID from URI route
    id = params[:id]
    # look up movie by unique ID
    @movie = Movie.find(id)
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # figure out if there was a previous session
    sort = params[:sort] || session[:sort]
    case sort
    # was it by title or release date
    when 'title'
      # sort ascending and apply hilite css
      ordering,@title_header = {:title => :asc}
      @css_title = 'hilite'
    when 'release_date'
      ordering,@release_date_header = {:release_date => :asc}
      @css_release_date = 'hilite'
    end
    # pull the all ratings from the active record of `movie.rb`
    @all_ratings = Movie.all_ratings
    @selected_ratings = params[:ratings] || session[:ratings] || {}
    # start a new hash if a new session
    if @selected_ratings == {}
      @selected_ratings = Hash[@all_ratings.map {|rating| [rating, rating]}]
    end
    # update the old session if the filtering scope changed
    if params[:sort] != session[:sort] or params[:ratings] != session[:ratings]
      session[:sort] = sort
      session[:ratings] = @selected_ratings
      redirect_to :sort => sort, :ratings => @selected_ratings and return
    end
    # return the movies where the filtering reuqirements match
    @movies = Movie.where(rating: @selected_ratings.keys).order(ordering)
  end

  def new
    # default: render 'new' template
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
