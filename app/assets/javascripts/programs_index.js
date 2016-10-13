;(function() {
  'use strict;';

  var root = this;

  root.programsIndexFunc = function() {
    $(function() {

      $('.reserve_link').on('click', function() {
        $.ajax({
          url: $(this).attr('href'),
          type: 'POST',
          dataType: 'json',
          success: function(data, textStatus, jqXHR) {
            if (data.result === 'OK') {
              $.gritter.add({
                text: data.message,
                class_name: 'growl-primary',
                image: false,
                sticky: false
              });
            } else {
              $.gritter.add({
                text: data.message,
                class_name: 'growl-danger',
                image: false,
                sticky: false
              });
            }
          },
        });
        return false;
      });

    });
  };

}).call(this);
