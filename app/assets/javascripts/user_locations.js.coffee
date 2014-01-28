jQuery ->

	$('.checkin-form-step-1').submit ->
		returnValue = true
		if (userId == undefined)
			$('#logInModal').modal('show')
			returnValue = false
		else
			if ($(this).validate())
				$(this).submit()
			returnValue = false
		return returnValue

	markers = new Array()
	locationsMap = null
	infoWindow = new google.maps.InfoWindow()

	loadLocations = () ->
		if $("#locationsMap").length > 0
			locationsMap = new google.maps.Map($("#locationsMap").get(0), {
				panControl: false,
				zoomControl: false,
				mapTypeControl: false,
				scaleControl: false,
				streetViewControl: false,
				overviewMapControl: false,
				maxZoom: 8,
				mapTypeId: google.maps.MapTypeId.ROADMAP
			})
			latlngbounds = new google.maps.LatLngBounds()
			loadLocation(locationInfo) for locationInfo in userLocations
			latlngbounds.extend( marker.position ) for marker in markers
			locationsMap.fitBounds(latlngbounds)
			locationsMap.center = latlngbounds.getCenter()

	loadLocation = (locationInfo) ->
		latitude = locationInfo[0]
		longitude = locationInfo[1]
		address = locationInfo[2]
		location = new google.maps.LatLng(latitude, longitude);
		marker = new google.maps.Marker({position:location, title:address, map:locationsMap})
		markers.push(marker)
		google.maps.event.addListener(marker, 'click', ()->
			infoWindow.setOptions({position:marker.position, content: address}) 
			infoWindow.open(locationsMap, marker)
		)
		
	loadLocations()