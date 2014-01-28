jQuery ->
  mapCanvas = '#map-canvas'
  dataLocation = 'data-location'
  infoWindow = new google.maps.InfoWindow()
  
  if $(mapCanvas).length > 0
    mapCenter = $('#map-center').attr(dataLocation).split(',')
    mapOptions = {
            center: new google.maps.LatLng(mapCenter[0], mapCenter[1]),
            zoom: 8,
            mapTypeId: google.maps.MapTypeId.ROADMAP
          }
    map = new google.maps.Map($(mapCanvas)[0],
              mapOptions)
    
    $('.map-point').each (i) ->
      coordinates = $(this).attr(dataLocation).split(',')
      name = $(this).attr('data-name')
      marker = new google.maps.Marker({
          position: new google.maps.LatLng(coordinates[0], coordinates[1])
          map: map
        })    
        
      google.maps.event.addListener(marker, 'click', ()->
          infoWindow.setContent(name)
          infoWindow.open(map,this)
        )   
