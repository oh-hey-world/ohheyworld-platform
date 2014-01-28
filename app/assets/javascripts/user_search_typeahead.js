$(document).ready(function () {
  var arr = [];
  var keyValues = [];
  var mappedItems = {};
  var searchBox = $('#user-tag-typeahead');
  var locationSlug = $('#js-user-location');

  submitTagSearch = function(item) {
    keyValue = mappedItems[item];
    if (keyValue.type == 'user') {
      $('.js-user-tag-id').val(keyValue.id);
    } else {
      $('.js-provider-friend-tag-id').val(keyValue.id);
    }
    $('.js-user-tag-form').submit();
  }

  var typeahead = searchBox.typeahead({items: 20,
    updater:function (item) {submitTagSearch(item)},
    highlighter: function(item) {
      var parts = item.split('#');
      var html = ''
        + "<div class='typeahead_wrapper'>"
        + "<img class='typeahead_photo' src='" + parts[1] + "' />"
        + "<div class='typeahead_labels'>"
        + "<div class='typeahead_primary'>" + parts[0] + "</div>"
        + "</div>"
        + "</div>";
      return html;
    }
  }).data('typeahead');
  if (typeahead != null) {
    typeahead.$menu.width(searchBox.outerWidth());
  }

  var autocomplete = searchBox.typeahead()
    .on('keyup', function (ev) {
      ev.stopPropagation();
      ev.preventDefault();

      //filter out up/down, tab, enter, and escape keys
      if ($.inArray(ev.keyCode, [40, 38, 9, 13, 27]) === -1) {
        var self = $(this);
        //set typeahead source to empty
        self.data('typeahead').source = [];

        //active used so we aren't triggering duplicate keyup events
        if (!self.data('active') && self.val().length > 0) {
          self.data('active', true);
          $.ajax({
            url:'/user_searches/search_users.json?q=' + $(this).val() + '&user_location_id=' + locationSlug.val(),
            dataType:'json',
            cache:false,
            success:function (data, status, xhr) {
              self.data('active', true);
              arr = [];
              keyValues = [];
              mappedItems = {};

              for (var i=0; i < 4; i++) {
                if (data.users[i] != null) {
                  var user = data.users[i].user;
                  var user_data = user.first_name + ' ' + user.last_name + '#' + user.picture_url
                  keyValues.push({"label": user_data, "type":"user", "id": user.id});
                }
              }

              for (var i=0; i < 4; i++) {
                if (data.provider_friends[i] != null) {
                  var provider_friend = data.provider_friends[i].provider_friend;
                  var provider_friend_data = provider_friend.user_name + '#' + provider_friend.picture_url
                  keyValues.push({"label": provider_friend_data, "type":"provider_friend", "id": provider_friend.id});
                }
              }

              $.each(keyValues, function (i, item) {
                mappedItems[item.label] = {"type": item.type, "id": item.id};
                arr.push(item.label);
              });

              //set your results into the typehead's source
              self.data('typeahead').source = arr;
              //trigger keyup on the typeahead to make it search
              self.trigger('keyup');

              //All done, set to false to prepare for the next remote query.
              self.data('active', false);
            },
            error:function (xhr, status, error) {
            }
          })
        }
      }
    });
});