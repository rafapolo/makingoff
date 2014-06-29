module ApplicationHelper

  def link_to_mko m
    return "http://makingoff.org/?=#{m.mko_id}"
  end

  def capa_image_for m
    path = "http://graficautopica.net/assets/capas/#{m.id}.jpg"
    image_tag(path)
  end

  def aprox_hours_ago(time)
    aprox_hours = ((Time.now - time)/60/60).to_i
    "#{aprox_hours} horas atrás" if aprox_hours > 1
  end

  def style_for m
    case m.count
      when nil
        'border-preto'
      when 0
        'border-vermelho'
      when 1..5
        'border-laranja'
      when 6..10
        'border-amarelo'
      else
        'border-verde'
      end
  end

  def mko_link m
    "http://makingoff.org/forum/index.php?showtopic=#{m.mko_id}"
  end

  def quantos_vivos
    number_with_delimiter(Movie.vivos.count, delimiter: ".")
  end

  def movie_size m
    number_to_human_size(m.torrent_size)
  end

  def quantos_vivos_size
    number_to_human_size(Movie.vivos.sum(:torrent_size))
  end
end
