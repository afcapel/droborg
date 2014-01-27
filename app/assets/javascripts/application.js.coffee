#= require jquery
#= require jquery_ujs
#= require turbolinks
#= require bootstrap
#= require select2

$(document).on 'click', 'a[rel=modal]', (event)->

  $.ajax this.href,
    data: { modal: true },
    success: (data, textStatus, xhr)->
      $('#modal').replaceWith(data)
      $('#modal').modal('show')

  event.stopPropagation()
  event.preventDefault()

poll = (element)->
  polledElement = $(element)
  pollUrl       = polledElement.data('poll-url') || location.href
  pollInterval  = polledElement.data('poll-interval') || 2000
  selector      = '#' + $(element).attr('id')

  setTimeout ->
    $.ajax pollUrl,
      success: (data, textStatus, jqXHR) ->
        updated = $(data).find(selector) unless jqXHR.statusCode() == 304
        $(selector).replaceWith(updated).trigger('poll:update')

  , pollInterval

$(document).on 'page:update poll:update', (event) ->
  $('#branches_select').select2({ width: '200px' })
  $('[data-poll-url]').each (index, element) -> poll(element)

$(document).on 'change', '#branches_select', ->
  $(this).closest('form').submit()

