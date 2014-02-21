class MoviesController < ApplicationController
  before_action :set_movie, only: [:show, :edit, :update, :destroy]

  def index
    page = params[:page] || 1
    @movies = Movie.limit(50)
  end

  def show

  end

  def autocomplete
    return false if !params[:nome] || !params[:tipo]
    data = []
    classe = params[:tipo].capitalize.constantize
    classe.where("nome LIKE ?", "%#{params[:nome]}%").each do |d|
      data << {id: d.id, value: d.nome, count: d.count}
    end
    render json: data
  end

  private
    def set_movie
      @movie = Movie.find(params[:id])
    end

    def movie_params
      params.require(:movie).permit(:nome, :original, :mko_id, :ano)
    end
end
