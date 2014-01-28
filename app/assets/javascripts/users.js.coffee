jQuery ->

  networkMapName = '#network-map'
  networkMap = null
  networkInfoWindow = null
  providerUrl = "/provider_friends/grouped_friends?scope="
  friendUrl = "/user_friends/grouped_friends?scope="

  friendMarkerIndex = 0
  friendsMarkerMessages = new Array()
  friendsMarkers = new Array()

  setupProfileEvents()

  getFriends = (baseUrl, scope) ->
    url = "#{baseUrl}#{scope}"
    $.ajax url,
      type: 'GET'
      dataType: 'json'
      error: (jqXHR, textStatus, errorThrown) ->
        alert("Error getting your friends")
      success: (data, textStatus, jqXHR) ->
        addFriendsToMap(data)

  addFriendsToMap = (data) ->
    for item in data.grouped_parents
      addGroupMap(item)
    latlngbounds = new google.maps.LatLngBounds()
    latlngbounds.extend( marker.position ) for marker in friendsMarkers
    networkMap.fitBounds(latlngbounds)
    networkMap.center = latlngbounds.getCenter()

  addGroupMap = (item) ->
    grouped_parent = item.grouped_parent
    child_message = ""
    child_sum_count = 0
    scope =  grouped_parent.scope
    type = grouped_parent.type
    countryName = null
    stateName = null
    if grouped_parent.country_name != undefined
      countryName = grouped_parent.country_name

    if grouped_parent.name != undefined
      stateName = grouped_parent.name

    if (type == "ProviderFriends")
      base_url = "/provider_friends/network?country=#{countryName}"
    else
      base_url = "/user_friends/network?country=#{countryName}"

    base_url += "&state=#{stateName}"

    for item in grouped_parent.children
      child = item.child
      child_message += "<a href='#{base_url}&city=#{child.city_name}'>#{child.city_name}</a> (#{child.count_all}) <br/>"
      child_sum_count += parseInt(child.count_all)
    message = "You have (#{child_sum_count}) friends in #{stateName}<br/>"
    message += child_message
    friendsMarkerMessages.push(message)
    openFriendLocation(friendMarkerIndex, grouped_parent)
    friendMarkerIndex++

  $(document).on('ajax:success', '.js-remove-tag-form', ( ->
    friendSubmit = $(this).find('.js-remove-tag-submit')
    text = if (friendSubmit.val() == "Add") then "Remove" else "Add"
    friendSubmit.val(text)
  ))

  #====== follow form ======#
  $(document).on('ajax:success', '.js-add-to-profile-tag-form', (xhr, data, status) ->
    button = $(this).closest('.btn-group').find('.js-profile-tag-button')
    unfollow = $(this).parent().parent().find('.js-profile-form-unfollow')
    hiddenLi = $(this).parent().parent().find('.js-profile-hidden')
    if (data == "")
      button.val("Follow")
      tagName = $(this).find('.js-profile-follow-tag')
      tagName.val("Follow")
      unfollow.hide()
      lis = $(this).parent().find('li')
      unless lis.length > 0
        lis = $(this).parent().parent().find('li')
      for li in lis
        link = $(li).find('.js-add-to-profile-tag')
        setTagLink(link, true)
    else
      input = $(this).find('.js-profile-tag-input')
      if (input.length > 0)
        newNode = $(this).parent().parent().find('.js-profile-form-empty').clone(true)
        newNode.removeClass('js-profile-form-empty')
        tagName = newNode.find('.js-profile-tag-name')
        tagName.val(input.val())
        newNode.find('.js-add-to-profile-tag').text(input.val())
        newNode.find('.js-add-to-profile-tag').addClass('js-unfollow-tag')
        newNode.attr('style', '')
        newNode.insertBefore(hiddenLi)
        input.val("")
      else
        tagName = $(this).find('.js-profile-follow-tag')
        unless (tagName.length == 0)
          tagName.val("Following")
      button.val("Following")
      unfollow.show()
      link = $(this).find('.js-add-to-profile-tag')
      setTagLink(link, false)
  )

  $(document).on('keyup', '.js-profile-tag-input', ( (event) ->
    if (event.keyCode == 13)
      $(this).closest('.btn-group').find('.dropdown').dropdown('toggle')
  ))

  $('.dropdown-menu').on('click', '.js-profile-tag-input', ( (event) ->
    event.stopPropagation()
  ))

  setTagLink = (link, override) ->
    linkText = link.text().toLowerCase()
    unless (linkText.indexOf("unfollow") >= 0 || linkText.indexOf("follow") >= 0)
      #link.removeClass('js-follow-tag')
      #link.removeClass('js-unfollow-tag')
      if override
        link.addClass('js-follow-tag')
      else
        unless (linkText.indexOf("unfollow") >= 0)
          if link.hasClass('js-follow-tag')
            replacement = "js-unfollow-tag"
            link.removeClass('js-follow-tag')
          else
            replacement = "js-follow-tag"
            link.removeClass('js-unfollow-tag')
        link.addClass(replacement)

  $(document).on('ajax:error', '.js-add-to-profile-tag-form', ( ->
     alert('failed to update the tag')
  ))
  #====== follow form ======#

  $('.js-contact-form-display').bind 'click', (event) ->
    event.preventDefault()
    $('.js-contact-form').toggle()

  $(".js-contact-form")
  .bind 'ajax:success', ->
    $('.js-contact-form').toggle()
  .bind 'ajax:failure', -> alert("Error following user")

  openFriendLocation = (index, grouped_parent) ->
    marker = new google.maps.Marker({
      position: new google.maps.LatLng(grouped_parent.latitude, grouped_parent.longitude)
      map: networkMap
    })
    friendsMarkers.push(marker)
    google.maps.event.addListener(marker, 'click', () ->
      networkInfoWindow.setContent(friendsMarkerMessages[index])
      networkInfoWindow.open(networkMap, marker)
    )

  if ($(networkMapName).length > 0)
    networkInfoWindow = new google.maps.InfoWindow()
    center = new google.maps.LatLng(currentLatitude, currentLongitude)
    mapOptions = {mapTypeId: google.maps.MapTypeId.ROADMAP, zoom: 8, center: center}
    networkMap = new google.maps.Map($(networkMapName).get(0), mapOptions)
    getFriends(providerUrl, 'US')
    getFriends(providerUrl, 'World')

  $('.friends-map-selector').click ->
    marker.setMap(null) for marker in friendsMarkers
    friendMarkerIndex = 0
    friendsMarkerMessages = new Array()
    friendsMarkers = new Array()
    if ($(this).val() == 'facebook_friends')
      getFriends(providerUrl, 'US')
      getFriends(providerUrl, 'World')
    else
      getFriends(friendUrl, 'US')
      getFriends(friendUrl, 'World')

  $('.location-input').focus ->
    $('.location-input').val("")

  $('.location-input').blur ->
    setLocation()

  setLocation = () ->
    if ($('.location-input').length > 0 && $('.location-input').val().length == 0)
      locationInfo = [geoip_city(), geoip_region(),  geoip_country_code()]
      $('.location-input').val(locationInfo.join(', '))

  setLocation()

  $('.js-privacy-update').change ->
    $(this).parents('form:first').submit()

  $(document).on('ajax:success', '.js-invite-friend', ( ->
    $(this).find('.js-friend-email').val('We invited them')
  ));

  $(document).on('ajax:failure', '.fb-invite-friend', ( ->
    alert("Error following user")
  ));

  $('.js-segment-tags').bind 'click', ->
    window.location = window.location.pathname + '?interests=' + ($(this).hasClass('js-interests'))

window.showHideEditPanes = (tripItem) ->
  editPane = tripItem.children('.trip-options.dropdown').children('.dropdown-menu')
  savePane = tripItem.children('.trip-dialog-save-cancel')
  editPane.show()
  savePane.hide()

window.swapEditForReadDates = (leftSelector, rightSelector, item) ->
  left = item.find(leftSelector).eq(0)
  right = item.find(rightSelector).eq(0)
  right.text(left.val())
