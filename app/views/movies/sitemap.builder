xml.instruct!
xml.urlset "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9" do
  @movies.each do |movie|
    xml.url do
      xml.loc "http://acervo.herokuapp.com/filme/#{movie.urlized}"
      xml.lastmod movie.created_at.to_date
    end
  end
  @directors.each do |director|
    xml.url do
      xml.loc "http://acervo.herokuapp.com/list/director/#{director.id}"
      xml.lastmod director.created_at.to_date
    end
  end
end
