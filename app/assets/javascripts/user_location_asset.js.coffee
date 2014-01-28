jQuery ->

  $(document).on('ajax:success', '.js-checkin-asset', (xhr, data, status) ->
    $(this).parent().hide()
  )