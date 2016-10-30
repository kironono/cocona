;(function() {
  'use strict;';

  var root = this;

  root.logsIndexFunc = function() {
    $(function() {
      var sourceUrl = $('#log_source_url').val();
      var $logs = $('#logs');
      var es = new EventSource(sourceUrl);

      es.addEventListener('message', function (event) {
        $logs.val($logs.val() + event.data + "\n");
        $logs.scrollTop(
          $logs[0].scrollHeight - $logs.height()
        );
      });

    });
  };

}).call(this);
