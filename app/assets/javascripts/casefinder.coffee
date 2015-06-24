$ ->
  $(".datepicker").datepicker
    altFormat: "yy-mm-dd"
    dateFormat: "yy-mm-dd"
    changeMonth: true
    changeYear: true

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