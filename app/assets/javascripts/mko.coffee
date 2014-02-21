$ ->
  document.title = "Acervo | ▲ 2312 ▼ 2386"

  $('.capa').click ->
    id = $(this).attr('id')
    titulo = $(this).children().next().text()
    $('#info').text(titulo)

  # para toda capa
  $('.capa>img')
    .on 'mouseenter', -> $(this).animate(opacity: 1, 200)
    .on 'mouseleave', -> $(this).animate(opacity: 0.5, 200)
    .load -> $(this).fadeIn 1500 # exibe capa quando carregar
    # todo: mudar compormento em tablets; sem opacidade

  termTemplate = "<span class='ui-autocomplete-term'>%s</span>";
  $.each ['director', 'country', 'genre', 'movie'], (i, tipo) ->
    $("##{tipo}").autocomplete
      minLength: 3
      delay: 200
      source: (request, response) ->
        $.getJSON "/autocomplete.json?tipo=#{tipo}&nome=" + request.term, (data) -> response data
      select: (e, ui) -> console.log ui

    .data("ui-autocomplete")._renderItem = (ul, item) ->
      tipo = $(document.activeElement).attr('id')
      if item.count == 1 # refatorar
        count_title = if tipo == 'movie' then 'diretor' else 'filme'
      else
        count_title = if tipo == 'movie' then 'diretores' else 'filmes'

      $("<li>").append("<a>#{item.value}<p class='sub'>#{item.count} #{count_title}</p></a>").appendTo ul


  $("#anos-range").slider
    range: true
    min: 1892
    max: 2014
    values: [1940, 1980]
    slide: (event, ui) -> updateAnos()

  updateAnos = -> $("#ano").text $("#anos-range").slider("values", 0) + " - " + $("#anos-range").slider("values", 1)
  updateAnos()

  $('img')
  setInterval (-> $("img").fadeIn(800)), 3000 # em 3s exibe todas as capas
