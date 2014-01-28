jQuery ->
  $('.how-it-works-controller').click -> 
    $('.how-it-works-target').toggle()
  
  $('#email_sms_parents').click ->
    if ($(this).is(':checked'))
      $('#parents-form').show()
    else
      $('#parents-form').hide()
      
  $('#email_sms_friends').click ->
    if ($(this).is(':checked'))
      $('#friends-form').show()
    else
      $('#friends-form').hide()
  
  $('#add-new-parent').click ->
    $.ajax '/' + userId + '/new_notification_contact_details',
      type: 'GET'
      dataType: 'html'
      error: (jqXHR, textStatus, errorThrown) ->
        alert("Error adding your record")
      success: (data, textStatus, jqXHR) ->
        $('#new-parent-entries').append(resetIds(data))
    false
    
  $('#add-new-friend').click ->
    $.ajax '/' + userId + '/new_notification_contact_details',
      type: 'GET'
      dataType: 'html'
      error: (jqXHR, textStatus, errorThrown) ->
        alert("Error adding your record")
      success: (data, textStatus, jqXHR) ->
        $('#new-friends-entries').append(resetIds(data))
    false
  
  $('#done-with-parents').click ->
    $('#parents-form').hide()
    $('#friends-form').show()
    false
   
  $('#import_friends').click -> 
    if ($(this).is(':checked') || $(this).is('button'))
      toggleActivityIndictor()
      $.ajax '/' + userId + '/import_facebook_friends',
        type: 'POST'
        dataType: 'json'
        complete: (jqXHR, textStatus) ->
          if (textStatus == 'error' || !jqXHR.responseText)
            alert("Error importing your friends")
          else
            pollFBResponse()
        window.location.href = '#'  
    return ($(this).is(':checked'))
        
  pollFBResponse = () ->
    $.ajax '/' + userId + '/import_facebook_friends_finished', 
      success: (data, textStatus, jqXHR) ->
        if (data != null && data != "")
          $('#fbUsersNearby').html(data)
          toggleActivityIndictor()
        else
          setTimeout(pollFBResponse, 3000)
      error: (jqXHR, textStatus, errorThrown) ->
        alert("Error importing your friends")
      dataType: "html", 
      timeout: 60000
    

window.setupProfileEvents = () ->

  $(".edit_user_location")
    .bind "ajax:success", (event, data) ->
      tripItem = $(this).parent().parent()
      showHideEditPanes(tripItem)
    .bind "ajax:error", (event, data) ->
      alert('There was an error saving your change.  Please try again later.')

  $('input.ui-datepicker').datepicker();

  $('.js-trip-edit').bind 'click', (event) ->
    event.preventDefault()
    $(this).parents('.js-trip-item').children('.js-trip-edit-dialog').toggleClass('hide')

  $('.edit-trip').bind 'click', (event) ->
    editPane = $(this).parent().parent()
    editPane.hide()
    savePane = editPane.parent().next()
    savePane.show()
    false

  $('.cancel-edit-trip').click ->
    tripItem = $(this).parent().parent()
    showHideEditPanes(tripItem)
    false

  $('.save-edit-trip').click ->
    $(this).parent().prev().submit()
    false

  $('.js-trip-edit-cancel').bind 'click', (event) ->
    event.preventDefault();
    $(this).parents('.js-trip-edit-dialog').toggleClass('hide')

window.validatePhoneOrEmail = (input) ->
  unless (/^([a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]|[1]?[\-|\s|\.]?\(?[0-9]{3}\)?[\-|\s|\.]?[0-9]{3}[\-|\s|\.]?[0-9]{4})$/i.test(input.val()))
    alert('Invalid phone number or email address')

window.validateNotBlank = (input, name) ->
  if (input.val() == null || input.val() == "")
    alert('Invalid ' + name)