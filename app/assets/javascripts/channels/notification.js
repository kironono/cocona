(function() {

  App.notificationChannel = App.cable.subscriptions.create("NotificationChannel", {
    received: function(data) {
      jQuery.gritter.add({
        title: data.title,
        text: data.body,
        class_name: 'growl-primary',
        image: false,
        sticky: false,
        time: ''
      });
    }
  });

}).call(this);
