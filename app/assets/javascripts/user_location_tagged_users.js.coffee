jQuery ->

  $(document).on('ajax:success', '.js-tagged-user-container', (xhr, data, status) ->
    $(this).hide()
  )

  $(".js-user-tag-form")
    .bind 'ajax:success', (event, data) ->
      taggedUsers = $(this).parent().find('.js-users-tagged')
      parentContainer = $("<div class='js-tagged-user-container'>")
      if (data.provider_friend instanceof Object )
        provider_friend = data.provider_friend
        parentContainer.append(" #{provider_friend.user_name}")
        #taggedUsers.append(" <a href='#{provider_friend.link}'><img src='#{provider_friend.picture_url}'/></a>")
      else
        user = data.user
        parentContainer.append(" #{user.user_name}")
        #taggedUsers.append(" <a href='/#{user.slug}/profile'><img src='#{user.picture_url}'/></a>")
      parentContainer.append(" <a href='/user_location_tagged_users/#{data.tagged_id}' class='tagged-user' data-method='delete' data-remote='true' rel='nofollow'>x</a>")
      taggedUsers.append(parentContainer)
    .bind 'ajax:failure', ->
      alert("Error tagging user")