$(document).ready(function () {
    var typeahead = $('.js-location-input').typeahead().data('typeahead');
    if (typeahead != null) {
        typeahead.$menu.width($('.js-location-input').outerWidth());
    }

    var autocomplete = $('.js-location-input').typeahead()
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
                        url:'/locations.json?q=' + $(this).val(),
                        dataType:'json',
                        cache:false,
                        success:function (data, status, xhr) {
                            self.data('active', true);

                            var arr = [],
                                i = data.length;
                            while (i--) {
                                arr[i] = data[i].location.address
                            }

                            //set your results into the typehead's source
                            self.data('typeahead').source = arr;
                            //trigger keyup on the typeahead to make it search
                            self.trigger('keyup');

                            //All done, set to false to prepare for the next remote query.
                            self.data('active', false);
                        },
                        error:function (xhr, status, error) {
                        },
                    })
                }
            }
        });
});