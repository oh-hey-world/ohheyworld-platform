jQuery ->

  $('.js-comments').bind 'click', (event) ->
    event.preventDefault()
    $(this).parent().siblings('.js-comments-container').toggle()

  $('.js-city-checkin-item__edit-button').bind 'click', (event) ->
    event.preventDefault()
    $(this).parent().siblings('.js-city-checkin-item__edit').toggle()

  $('.js-city-checkin-item__edit-cancel').bind 'click', (event) ->
    event.preventDefault()
    $(this).parents('.js-city-checkin-item__edit').toggle()

  $('.js-notes').bind 'click', (event) ->
    event.preventDefault()
    $('.js-notes-container').toggle()

  $(".js-comment-like-form")
    .bind 'ajax:success', (event, data) ->
      $(this).parent().find('.js-comment-like').text(data.number_of_likes)
    .bind 'ajax:failure', -> alert("Error liking comment")

  $(".fb-user-advice-form")
    .bind 'ajax:success', (event, data) ->
      $(this).parent().parent().find('.fb-friend-email-advice').val('We invited them')
    .bind 'ajax:failure', ->
      alert("Error following user")
