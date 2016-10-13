;(function() {
  'use strict;';

  var root = this;

  root.reserveRulesIndexFunc = function() {
    $(function() {

      $('.toggle').map(function() {
        $(this).toggles({
          on: $(this).data('toggle-on')
        }).on('toggle', function(e, active) {
          var $t = $(this);
          var url = $t.data('href');
          $.post(url, function(data) {
          }, 'json');
        });
      });

    });
  };

}).call(this);
