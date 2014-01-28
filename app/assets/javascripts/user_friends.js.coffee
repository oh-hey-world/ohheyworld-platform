jQuery ->
  $(document).on('click', '.js-add-to-profile-tag', ( (event) ->
    event.preventDefault()
    $(this).parents('form:first').submit()
  ))

  $(".js-travel-feed-group").bind 'change', (event) ->
    window.location = window.location.pathname + '?view=' + $(this).val()

  $(".send-sms").bind 'click', (event) ->
    submitUserForm($(this))

  $(".send-email").bind 'click', (event) ->
    submitUserForm($(this))

  submitUserForm = (input) ->
    $('.submit-type').val('update')
    input.parent().submit()

  $('.friend-submit').bind 'click', (event) ->
    event.preventDefault()

  $(".follow-friend")
  .bind 'ajax:success', ->
    type = $('.submit-type').val()
    $('.submit-type').val('')
    friendSubmit = $(this).find('.friend-submit')
    text = null
    if (type != "update")
      if (friendSubmit.val() == "Follow")
        text = "Unfollow"
      else
        text = "Follow"
      friendSubmit.val(text)
  .bind 'ajax:failure', -> alert("Error following user")
