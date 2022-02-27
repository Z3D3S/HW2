# This file is app/controllers/movies_controller.rb
class MoviesController < ApplicationController
  def index
    @all_ratings = Movie.all_ratings
    if session[:ratings] != params[:ratings] && params[:ratings] != nil
      session[:ratings] = params[:ratings]
    end
    if session[:sort_by] != params[:sort_by] && params[:sort_by] != nil
      session[:sort_by] = params[:sort_by]
    end
    if params[:ratings] == nil && params[:sort] == nil && session[:ratings] != nil
      redirect_to movies_path(:sort_by => session[:sort_by], :ratings => session[:ratings])
    elsif params[:ratings] == nil && session[:ratings] != nil
      redirect_to movies_path(:sort_by => params[:sort_by], :ratings => session[:ratings])
    elsif params[:sort_by] == nil && session[:sort_by] != nil
      redirect_to movies_path(:sort_by => session[:sort_by], :ratings => params[:ratings])
    end
    ratings = params[:ratings]
    if ratings
      a = ratings.keys
    else
      a = @all_ratings
    end
    if params[:sort_by] == "title"
      @title_header = "hilite"
    elsif params[:sort_by] == "release_date"
      @release_date_header = "hilite"
    end
    @movies = Movie.order(params[:sort_by]).where(:rating => a)
  end

  def show
    id = params[:id]
    @movie = Movie.find(id)
  end

  def new
    @movie = Movie.new
  end

  def create
    #@movie = Movie.create!(params[:movie]) #did not work on rails 5.
    @movie = Movie.create(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created!"
    redirect_to movies_path
  end

  def movie_params
    params.require(:movie).permit(:title,:rating,:description,:release_date)
  end

  def edit
    id = params[:id]
    @movie = Movie.find(id)
    #@movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    #@movie.update_attributes!(params[:movie])#did not work on rails 5.
    @movie.update(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated!"
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find params[:id]
    @movie.destroy
    flash[:notice] = "#{@movie.title} was deleted!"
    redirect_to movies_path
  end
end