module ApplicationHelper

  def link_to_mko m
    return "http://makingoff.org/?=#{m.mko_id}"
  end

  def capa_for m
    file = "app//assets/images/capas/#{m.id}.jpg"
    path = File.exists?(Rails.root.join(file)) ? "capas/#{m.id}.jpg" : "capas/00.jpg"
    image_tag path
  end

end
