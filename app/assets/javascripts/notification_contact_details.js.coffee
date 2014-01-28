jQuery ->

  $('.js-add-email-contact').bind 'click', (event) ->
    event.preventDefault()
    addNotificationContact($(this), 'E-mail')

  $('.js-add-sms-contact').bind 'click', (event) ->
    event.preventDefault()
    addNotificationContact($(this), 'Sms')

  addNotificationContact = (element, name) ->
    count = element.parent().find('.js-notification-contact-detail').length * 2
    count++
    detail = element.parent().find('.js-notification-contact-detail:first').clone()
    detail.children().each (index, element) =>
      element.id = element.id.replace('0', '' + count + '')
      element.name = element.name.replace('0', '' + count + '')
      switch index
        when 2 then element.value = ''; element.placeholder = 'Name'
        when 3 then element.value = ''; element.placeholder = name

    element.parent().find('.js-notification-contacts').append(detail)
