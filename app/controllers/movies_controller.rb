class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
        @all_ratings = Movie.uniq.pluck(:rating)
	@record = Hash.new()
	@all_ratings.each do|rating|
	@record[rating] = true
	end
	#session[:id] = params[:id] if params[:id]
	if(params[:id])
		session[:id] = params[:id]
	end
	#session[:ratings] = params[:ratings] if params[:ratings]
	if(params[:ratings])
		session[:ratings] = params[:ratings]
	end
#redirect code
	if((params[:ratings] == nil && session[:ratings] != nil) || (params[:id] == nil && session[:id] != nil))
		flash.keep		
		redirect_to movies_path(:id => session[:id], :ratings => session[:ratings])
	end	
#ends

	if(session[:ratings])
		@rtng = session[:ratings].keys
		if(@rtng)
			@rtng.each do|rating|
			@record[rating] = true				
			end			
		end
	end
    #if(params[:id] == "title_header")
    if(session[:id] == "title_header")
	if(@rtng)
		@movies = Movie.where(rating: @rtng).order(:title)
		@cls_name1 = "hilite"
		@all_ratings.each do|rating|
		@record[rating] = false
		end
		@rtng.each do|rating|
		@record[rating] = true
		end
	else
		@movies = Movie.order(:title)
		@cls_name1 = "hilite"
	end
	#	

    #elsif(params[:id] == "release_date_header")
    elsif(session[:id] == "release_date_header")
	if(@rtng)
		@movies = Movie.where(rating: @rtng).order(:release_date)
		@cls_name2 = "hilite"		
		@all_ratings.each do|rating|
		@record[rating] = false
		end
		@rtng.each do|rating|
		@record[rating] = true
		end
	else
		@movies = Movie.order(:release_date)
		@cls_name2 = "hilite"
	end
	#	
    #elsif(params[:ratings] == nil)
    elsif(session[:ratings] == nil)  
	@movies = Movie.all
    else
	#@rtng = params[:ratings].keys
	@rtng = session[:ratings].keys	
	@movies = Movie.where(rating: @rtng)
	@all_ratings.each do|rating|
	@record[rating] = false
	end
	@rtng.each do|rating|
	@record[rating] = true
	end
  end
	
    
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
