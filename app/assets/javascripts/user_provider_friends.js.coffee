jQuery ->

  $(document).on('ajax:success', '.fb-follow-friend', ( ->
    friendSubmit = $(this).find('.fb-friend-submit')
    text = if (friendSubmit.val() == "Follow") then "Unfollow" else "Follow"
    friendSubmit.val(text)
  ));

  $(document).on('ajax:failure', '.fb-follow-friend', ( ->
    alert("Error following user")
  ));

  $(document).on('ajax:success', '.fb-invite-friend', ( ->
    $('.fb-user-invite-form').hide()
    $(this).parent().parent().find('.js-fb-friend-invited').text('We invited them')
  ));

  $(document).on('ajax:failure', '.fb-invite-friend', ( ->
    $('.fb-user-invite-form').hide()
    alert("Error following user")
  ));

  $(document).on('click', '.invite-to-ohw', ( ->
    userForm = $(this).siblings('.fb-user-invite-form')
    userForm.toggle()
  ));
