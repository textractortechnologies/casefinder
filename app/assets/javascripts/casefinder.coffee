$ ->
  $(".datepicker").datepicker
    altFormat: "yy-mm-dd"
    dateFormat: "yy-mm-dd"
    changeMonth: true
    changeYear: true

  new Casefinder.Autologout()

(exports ? this).Casefinder = {}

(exports ? this).Casefinder.PathologyCasesUI = (config) ->
    sites = JSON.parse($('.sites').html())
    histologies = JSON.parse($('.histologies').html())
    source = sites.concat(histologies)
    $('#search').catcomplete source: source
    return

(exports ? this).Casefinder.BatchExportUI = (config) ->
    $('#batch_exports').combobox(watermark: 'export')
    $('#batch_exports').change ->
      batchExportUrl = new (Casefinder.Url)(config.batchExportUrl)
      window.location.href = batchExportUrl.sub(id: $(this).val())
    if parseInt(config.not_fully_set_abstractor_abstraction_groups_size) > 0
      $('.create_batch_export_link').prop('disabled', true)
      $('.create_batch_export_link').addClass('create_batch_export_link_disabled')
    return

(exports ? this).Casefinder.Url = (url) ->
  @url = url
  return

(exports ? this).Casefinder.Url.prototype =
  sub: (params) ->
    url = @url
    newUrl = @url
    queryString = []
    encodedArg = undefined
    encodedParam = undefined
    param = undefined
    for param of params
      `param = param`
      if params.hasOwnProperty(param)
        encodedParam = encodeURIComponent(param)
        encodedArg = encodeURIComponent(params[param])
        newUrl = url.replace(':' + param, encodedArg)
        if url == newUrl
          queryString.push encodedParam + '=' + encodedArg
        url = newUrl
    if queryString.length > 0
      if url.indexOf('?') > 0
        url + queryString.join('&')
      else
        url + '?' + queryString.join('&')
    else
      url
  parameters: ->
    $.map @url.match(/:\w+/g) or [], (o, i) ->
      o.substring 1

(exports ? this).Casefinder.Autologout = () ->
  # adopted from https://codedecoder.wordpress.com/2014/05/01/jquery-inactivity-warning-logout-timer-setinterval-clearinterval/
  # create main_timer and sub_timer variable with 0 value, we will assign them setInterval object
  main_timer  = 0
  sub_timer   = 0

  # within dialog_set_interval function we have created object of setInterval and assigned it to main_timer.
  # within this we have again created an object of setInterval and assigned it to sub_timer. for the main_timer
  # value is set to 15000000 i,e 25 minute. note that if subtimer repeat itself after 5 minute we reload the page
  dialog_set_interval = ->
    if $('#user_logged_in').val() == 'true'
      main_timer = setInterval((->
        $('#inactivity_warning').foundation('reveal', 'open')
        sub_timer = setInterval((->
          window.location = window.location
          return
        ), 300000)
        return
      ), 1500000)
      return

  # maintimer is set to 0 by calling the clearInterval function. note that clearInterval function takes
  # setInterval object as argument, which it then set to 0
  reset_main_timer = ->
    clearInterval main_timer
    dialog_set_interval()
    return

  $(".inactivity_ok").click () ->
    clearInterval sub_timer

  # reset main timer i,e idle time to 0 on mouse move, keypress or reload
  reset_main_timer()

  $(document).keypress ->
    reset_main_timer()
