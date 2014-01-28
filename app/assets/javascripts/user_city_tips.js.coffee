jQuery ->

  $(".js-tip-like-form")
    .bind 'ajax:success', (event, data) ->
      $(this).parent().find('.js-tip-like').text(data.number_of_likes)
    .bind 'ajax:failure', -> alert("Error liking tip")
