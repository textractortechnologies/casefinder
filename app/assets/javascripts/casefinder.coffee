$ ->
  $(".datepicker").datepicker
    altFormat: "yy-mm-dd"
    dateFormat: "yy-mm-dd"
    changeMonth: true
    changeYear: true
  return

  ## Display hide/show wording on accordion click
  $(document).on 'click', 'dl.accordion dd a', () ->
    if $(this).closest('dd').hasClass('active')
      $(this).find('i.fi-minus').removeClass('fi-minus').addClass('fi-plus')
    else
      $(this).find('i.fi-plus').removeClass('fi-plus').addClass('fi-minus')

(exports ? this).PathologyCasesUI = (config) ->
    sites = JSON.parse($('.sites').html())
    $('#search').autocomplete source: sites

    return