kExec = ->
  kc = $('#konami_code')
  bre = $('.bretzel')
  car = $('.caribou')
  external_link = kc.find('.btn-external-link')
  game_url = 'http://operasoftware.github.com/Emberwind/'

  kc.on 'show', ->
    kc.find('iframe').attr 'src', game_url
    external_link.attr 'href', game_url
    $('body').toggleClass 'canada'
    $.post '/theme'


  kc.on 'hide', ->
    kc.find('iframe').attr 'src', ''

  kc.modal()
  external_link.on 'click', ->
    kc.modal('hide')

$ ->
  Kpress = (e) ->
    kKeys.push e.keyCode
    if kKeys.toString().indexOf("38,38,40,40,37,39,37,39,66,65") >= 0
      jQuery(this).unbind "keydown", Kpress
      kExec()
  kKeys = []
  jQuery(document).keydown Kpress
