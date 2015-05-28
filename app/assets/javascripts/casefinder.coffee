$ ->
  $(".datepicker").datepicker
    altFormat: "yy-mm-dd"
    dateFormat: "yy-mm-dd"
    changeMonth: true
    changeYear: true

(exports ? this).PathologyCasesUI = (config) ->
    sites = JSON.parse($('.sites').html())
    histologies = JSON.parse($('.histologies').html())
    source = sites.concat(histologies)
    $('#search').catcomplete source: source

    return