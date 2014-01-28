jQuery ->

  $('.js-staff-city').bind 'click', ->
    window.location = window.location.pathname + '?staff_city=' + $(this).is(':checked')

  $(".js-travel-profile").bind 'change', ->
    window.location = window.location.pathname + '?travel_profile=' + $(this).val()

  $(".js-user-city-tip-select").bind 'change', ->
    form = $(this).parents('form:first');
    window.location = "#{form.attr('action')}/#{$(this).val()}"

  $('.js-segment-tips').bind 'click', ->
    window.location = pathMinimumParameters + '?community=' + ($(this).hasClass('js-community'))
