class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def percent_up
    no_peer = Movie.preto.count + Movie.vermelho.count
    down_percent = (100 * no_peer) / Movie.count
    100 - down_percent # up %
  end

end
