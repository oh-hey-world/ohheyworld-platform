$(document).ready(function () {
    var arr = [];
    var keyValues = [];
    var mappedItems = {};
    var searchBox = $('#js-city-tag-search');

    submitLocationTagSearch = function(item) {
        keyValue = mappedItems[item];
        $('.search-value-id').val(keyValue.id);
        $('.search-type').val(keyValue.type) ;
        $('.js-search-form').submit();
    }

    var typeahead = searchBox.typeahead({items: 20, updater:function (item) {submitLocationTagSearch(item)}}).data('typeahead');
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
                        url:'/user_searches/site_search.json?q=' + $(this).val(),
                        dataType:'json',
                        cache:false,
                        success:function (data, status, xhr) {
                            self.data('active', true);
                            arr = [];
                            keyValues = [];
                            mappedItems = {};

                            /*for (var i=0; i < 4; i++) {
                                if (data.tags[i] != null) {
                                    keyValues.push({"label": data.tags[i].tag.name, "type":"tag", "id": data.tags[i].tag.id});
                                }
                            }*/

                            for (var i=0; i < 4; i++) {
                                if (data.locations[i] != null) {
                                    keyValues.push({"label": data.locations[i].location.address, "type":"location", "id": data.locations[i].location.id});
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