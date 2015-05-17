$.widget 'custom.catcomplete', $.ui.autocomplete,
  _create: ->
    @_super()
    @widget().menu 'option', 'items', '> :not(.ui-autocomplete-category)'
    return
  _renderMenu: (ul, items) ->
    that = this
    currentCategory = ''
    $.each items, (index, item) ->
      li = undefined
      if item.category != currentCategory
        ul.append '<li class=\'ui-autocomplete-category\'>' + item.category + '</li>'
        currentCategory = item.category
      li = that._renderItemData(ul, item)
      if item.category
        li.attr 'aria-label', item.category + ' : ' + item.label
      return
    return
