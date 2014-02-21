class Makingoff

  def clean txt
    txt.gsub('/', "-").gsub(/\)|\(|\./, '').gsub(/\s{2,}/, ' ').strip
  end

  def self.crawlear!
    puts ("="*40).yellow
    puts "\t MakingOff Copyfight".yellow
    puts ("="*40).yellow

    # login
    puts "Autenticando...".yellow
    browser = Mechanize.new
    browser.user_agent_alias = 'Mac Safari'
    browser.get('http://www.makingoff.org/forum/index.php') do |page|
      page.form_with(:id => 'login') do |f|
        f.ips_username  = 'polo'
        f.ips_password = '**********'
      end.click_button
    end
    puts "Ok".green

    # extração
    last_page = 768
    dir = Rails.root.join('public')
    last_page.downto(0) do |pagina|
      browser.get("http://indice.makingoff.org/?pg=#{pagina}") do |page|
        puts "Página #{pagina}".blue
        linhas = page.search('.linha')
        itens = linhas.count
        linhas.each do |row|
          links = row.search('a')
          source = links[0]['href']
          mko_id = source.match(/\d+/)[0].to_i
          ano = links[3].text.strip
          nome = clean links[0].text
          original = links[1].text
          genero = links[2].text
          diretor = links[4].text
          pais = links[5].text
          puts clean("#{ano} - #{nome} - #{diretor} - #{pais}").yellow

          movie = Movie.find_or_create_by(:nome=>nome, :original=>original, :ano=>ano, :mko_id=>mko_id)

          if File.exists?("#{dir}/torrents/#{movie.id}.torrent")
            puts "Já salvo".red
          else

            SEPARATOR = /,|\se\s|\/|\||;|-|\\|:|&|\n/
            # diretores
            diretor.split(SEPARATOR).each do{ |d| movie.directors << Director.find_or_create_by(:nome=>clean(d)) }
            # países
            pais.split(SEPARATOR).each do{ |n| movie.countries << Country.find_or_create_by(:nome=>clean(n)) }
            # generos
            genero.split(SEPARATOR).each do{ |g| movie.genres << Genre.find_or_create_by(:nome=>clean(g).capitalize) }
            movie.save

            begin
              # torrent, anexos e capa
              browser.get(source) do |movie_page|
                movie_page.search('//a[starts-with(@href, "http://makingoff.org/forum/index.php?app=core&module=attach&section=attach&attach_id=")]').each do |p|
                  if !p.text.empty? && !p['href'].empty?
                    file = p.text
                    src = p['href']
                    puts "=> #{file}".green
                    if file.end_with? ".torrent"
                      browser.get(src).save("#{dir}/torrents/#{movie.id}.torrent")
                    else
                      browser.get(src).save("#{dir}/files/#{movie.id}_#{file}")
                    end
                  end
                end
                capa_src = movie_page.search("img.bbc_img").first.values[1]
                ext = capa_src.split('.').last.gsub(/\?.+/, '').gsub(/\\|\//, '')
                browser.get(capa_src).save("#{dir}/capas/#{movie.id}.#{ext}")
                puts "=> capa: #{capa_src}".green
              end
            rescue Exception => e
              puts e.message.red
            end
          end
        end
      end
    end
  end
end
