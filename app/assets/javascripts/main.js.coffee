jQuery ->

  $("a[rel=popover]").popover()
  $(".tooltip").tooltip()
  $("a[rel=tooltip]").tooltip()
  $('.dropdown-toggle').dropdown()
  #getUserLocation()

  $('.checkin-text').focus ->
    $('.check-in-feed-new-item-dropdown').show()

  $('#nav-list-button').bind 'click', (event) ->
    event.preventDefault()
    $('#nav-sub-lists').toggle()

  $('.js-button-open').bind 'click', (event) ->
    event.preventDefault()
    $('.js-button-get-opened').toggleClass('reveal-vert')

  $('.js-profile-interests-edit').bind 'click', (event) ->
    event.preventDefault()
    form = $(this).parent().find('.js-profile-interests-form')
    tags = $(this).parent().find('.js-profile-interests')
    $(this).toggleClass("hidden")
    form.toggleClass("hidden")
    tags.toggleClass("hidden")

  $('.js-profile-interests-cancel').bind 'click', (event) ->
    event.preventDefault()
    toggleTagsForm($(this))

  toggleTagsForm = (element) ->
    form = $(element).parent()
    tags = form.parent().find('.js-profile-interests')
    edit = form.parent().find('.js-profile-interests-edit')
    edit.toggleClass("hidden")
    form.toggleClass("hidden")
    tags.toggleClass("hidden")


  $('#add-new-contact-email').click ->
    $.ajax '/' + userId + '/new_notification_contact_details?placeholder_value=E-mail&notification_type=EmailNotificationDetail&notification_show_enabled=true',
      type: 'GET'
      dataType: 'html'
      error: (jqXHR, textStatus, errorThrown) ->
        alert("Error adding your record")
      success: (data, textStatus, jqXHR) ->
        $('#new-email-contact-entries').append(resetIds(data))
    false

  $('#add-new-contact-sms').click ->
    $.ajax '/' + userId + '/new_notification_contact_details?placeholder_value=SMS&notification_type=SmsNotificationDetail&notification_show_enabled=true',
      type: 'GET'
      dataType: 'html'
      error: (jqXHR, textStatus, errorThrown) ->
        alert("Error adding your record")
      success: (data, textStatus, jqXHR) ->
        $('#new-sms-contact-entries').append(resetIds(data))
    false
    
  $('#twitter-login-settings').click ->
    openWindow('/users/auth/twitter', 'Login with Twitter', 880, 380)
    false

  $('#facebook-login-settings').click ->
    openWindow('/users/auth/facebook?state=dialog', 'Login with Facebook', 880, 380)
    false

  $('.facebook-settings-preference').click ->
    if ($(this).is(':checked'))
      $('#facebookLoginDialog').modal('show')

  $('.twitter-settings-preference').click ->
    if ($(this).is(':checked'))
      openWindow('/users/auth/twitter', 'Login with Twitter', 880, 380)

	$('#completeFriendAdd').click ->
		form = window.currentFriendForm
		close_friends = "Close Friends" if ($('#close_friends_tag').is(':checked')) 
		family = "Family" if ($('#family_tag').is(':checked'))
		form.find('input:.tag-list').val([close_friends, family, $('#other_friend_tags').val()].join(','))
		form.submit()

	$('.user-friend-contact-preference').change ->
		form = $(this).parents('form:first')
		form.submit()

@userId = $('#user').attr('data-id')
@userCompletedFirstCheckin = $('#user').attr('data-complated-first-checkin')
@isMobile = $('#isMobileDevice').attr('data-value')
@currentFriendForm = null
@currentLatitude = $('#user').attr('data-last-latitude')
@currentLongitude = $('#user').attr('data-last-longitude')

window.toggleActivityIndictor = () ->
  $('#activity-indicator').toggle()
  
window.getUserLocation = () ->
	userLocationInput = $('.location-input:first').val()
	if (navigator.geolocation && userLocationInput != undefined && userLocationInput.length == 0)
		navigator.geolocation.getCurrentPosition(setUserPosition)

window.handleTwitterCallback = () ->
  #TODO update UI elements
    
window.resetIds = (data) ->
  new_id = new Date().getTime()
  regexp = new RegExp("_0", "g")
  ids_replaced = data.replace(regexp, "_" + new_id)
  regexp = new RegExp("0\]", "g")
  final_output = ids_replaced.replace(regexp, new_id + "]")
  return final_output
  
window.openWindow = (url, title, w, h) ->
  left = (screen.width/2)-(w/2)
  top = (screen.height/2)-(h/2)
  popup = window.open(url, title, 
      'width='+w+', height='+h+', top='+top+', left='+left+', modal=no, resizable=no, toolbar=no, menubar=no,'+
      'scrollbars=no, alwaysRaise=yes'
    );
    
window.setUserPosition = (position) ->
  geocoder = new google.maps.Geocoder
  latlng = new google.maps.LatLng(position.coords.latitude, position.coords.longitude)
		geocoder.geocode(
			'latLng': latlng,
			(results, status) => 
				if status is google.maps.GeocoderStatus.OK
					arrAddress = results[0].address_components
					city = ''
					state = ''
					country = ''
					for address_component in arrAddress
          if (address_component.types[0] == "locality")
            city = address_component.long_name
          else if (address_component.types[0] == "country")
            country = address_component.short_name
          else if (address_component.types[0] == "administrative_area_level_1")
            state = address_component.long_name

          saveUserPosition(city + ", " + state + ", " + country)
		)

window.saveUserPosition = (name) ->
  $('.location-input').val(name)
  $.ajax '/user_locations/save_user_client_location',
    type: 'POST'
    data: user_client_location: name
    dataType: 'json'
    error: (jqXHR, textStatus, errorThrown) ->
    success: (data, textStatus, jqXHR) ->