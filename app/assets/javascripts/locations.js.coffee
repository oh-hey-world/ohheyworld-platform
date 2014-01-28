jQuery ->

  $(document).on('ajax:success', '.js-checkin-like-form', (xhr, data, status) ->
    $(this).parent().find('.js-checkin-like').text(data.number_of_likes)
  )

  $(document).on('ajax:failure', '.js-checkin-like-form', ( ->
    alert("Error liking checkin")
  ))