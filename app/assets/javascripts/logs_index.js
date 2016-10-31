;(function() {
  'use strict;';

  var root = this;

  root.logsIndexFunc = function() {
    $(function() {
      var logTarget = $('#log_target').val();
      var $logs = $('#logs');
      var currentOffset = -1;

      var logStreamChannel = App.cable.subscriptions.create("LogStreamChannel", {
        connected: function() {
          console.log('log_stream: connected');
          this.read_nextlines(currentOffset);
        },
        disconnected: function() {
          console.log('log_stream: disconnected');
        },
        received: function(data) {
          console.log('log_stream: received')
          var self = this;
          var line_count = data.lines.length;

          currentOffset = data.line_index;

          data.lines.forEach(function(line) {
            $logs.val($logs.val() + line + "\n");
            $logs.scrollTop(
              $logs[0].scrollHeight - $logs.height()
            );
          });

          if (line_count > 0) {
            self.read_nextlines(currentOffset);
          } else {
            setTimeout(function() {
              self.read_nextlines(currentOffset);
            }, 3000);
          }

        },
        read_nextlines: function(offset) {
          return this.perform('read_nextlines', {
            log_type: logTarget,
            offset: offset,
            limit: 100,
          });
        }
      });

    });
  };

}).call(this);
