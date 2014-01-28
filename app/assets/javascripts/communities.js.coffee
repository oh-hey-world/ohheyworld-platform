# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('#profile-connect').hide()
  connectClickState = false #the connect modal is hidden by default

  openConnect = ->
    $('#profile').hide()
    $('#profile-connect').slideDown('fast')
    connectClickState = true #the connect modal is currently showing

  closeConnect = ->
    $('#profile-connect').slideUp('fast', ->
        $('#profile').show()
    )
    connectClickState = false

  $('.connect-toggle').click ->
    event.preventDefault()
    if connectClickState
      closeConnect()
    else
      openConnect()

  $('.connect-end').click ->
    closeConnect()


  $('#modal-screen').prependTo('body').hide()

  $('.potential-member-menu').hide()
  $('.potential-member-options').hide()
  $('.potential-invite-modal').hide()

  $('.potential-member').hover((->

    memberBlock = this

    #small visual bump to mouseover member images
    $(this).animate({
      top: '+=-2'}, 'fast')

    potentialMemberOptions = $(this).children('.potential-member-options').html()

    # slides the Working menu down and clears old menu items
    workingMenu = $(this).nextAll('.potential-member-menu').first()

    $('.active-potential-menu').not(workingMenu).slideUp().empty().removeClass('active-potential-menu')
    workingMenu.addClass('active-potential-menu').empty().append(potentialMemberOptions).slideDown('fast', ->
      # on member picture mouseover, menu item shows as active
      $(this).find('.invite-menu-item').addClass('pure-li-hover-custom').click(->
        modalMaker(memberBlock)
      )
    )), (->
    $(this).animate({
      top: '0'}, 'fast')
    $(this).nextAll('.potential-member-menu').first().find('.invite-menu-item').removeClass('pure-li-hover-custom')
    )
  ).click ->
    event.preventDefault()
    modalMaker(this)

  modalMaker = (modalContainer) ->
    modalContent = $(modalContainer).find('.potential-invite-modal').clone(true)
    $('#modal-screen').append(modalContent).fadeIn('fast', ->
      $(this).children().slideDown('fast')
    )

  killModal = ->
    $('#modal-screen').fadeOut('fast').empty()

  $('#modal-screen').click ->
    if event.target == this
      killModal()

  $('.potential-invite-modal-end').click ->
    event.preventDefault()
    killModal()
