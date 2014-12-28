class MoviesController < ApplicationController
  before_action :set_movie, only: [:show, :edit, :update, :destroy]

  def info

  end

  def status
    @movies = Movie.send(params[:cor]).limit(50)

    if request.xhr? # ajax?
      render 'list', layout: false
    else
      render 'list'
    end
  end

  def list
    @page = params[:page] || 1
    @page= @page.to_i

    tipo = params[:tipo]
    id = params[:id]
    # only reply ajax with full params
    return if !tipo || !id

    obj = nil
    @movies = nil
    @titulo = nil
    if tipo == 'movie'
      @movies = [Movie.find(id)]
    else
      obj = tipo.capitalize.constantize.find(id)
      @movies = obj.movies.page(@page).per(50)
    end

    if request.xhr? # ajax?
      render 'list', layout: false
    else
      @title = "Acervo MKO ❤ #{obj.nome}"
      render 'list'
    end
  end

  def show
    @movie.update(last_show: Time.now)
    if request.xhr? # ajax?
      # show metainfo
      render 'show', layout: false
    else
      @movies = [@movie]
      render 'list'
    end
  end

  def autocomplete
    return false if !params[:nome] || !params[:tipo] || !request.xhr?
    data = []
    classe = params[:tipo].capitalize.constantize
    classe.where("nome LIKE ?", "%#{params[:nome]}%").each do |d|
      data << {id: d.id, value: d.nome, count: d.count}
    end
    render json: data
  end

  private
    def set_movie
      @movie = params[:urlized] ? Movie.find_by(urlized: params[:urlized]) : Movie.find(params[:id])
    end

    def movie_params
      params.require(:movie).permit(:nome, :original, :mko_id, :ano)
    end
end
