// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require video
//= require_tree .

(function() {
  "use strict";

  var root = this;

  $(function() {
    var $serverTime = $('span.current_server_time');
    var count = 0, currentTime = null;
    var formatDisplay = function(date) {
      var format = 'YYYY-MM-DD hh:mm:ss';
      format = format.replace(/YYYY/g, date.getFullYear());
      format = format.replace(/MM/g, ('0' + (date.getMonth() + 1)).slice(-2));
      format = format.replace(/DD/g, ('0' + date.getDate()).slice(-2));
      format = format.replace(/hh/g, ('0' + date.getHours()).slice(-2));
      format = format.replace(/mm/g, ('0' + date.getMinutes()).slice(-2));
      format = format.replace(/ss/g, ('0' + date.getSeconds()).slice(-2));
      if (format.match(/S/g)) {
        var milliSeconds = ('00' + date.getMilliseconds()).slice(-3);
        var length = format.match(/S/g).length;
        for (var i = 0; i < length; i++) format = format.replace(/S/, milliSeconds.substring(i, i + 1));
      }
      return format;
    }
    var updateTime = function() {
      if (currentTime === null || count > 30) {
        // server fetch
        $.getJSON('/server_infos/current_time', function(data) {
          currentTime = data.epoch_milliseconds;
          count = 1;
          $serverTime.html(formatDisplay(new Date(currentTime)));
        });
      } else {
        currentTime += 1000;
        count += 1;
        $serverTime.html(formatDisplay(new Date(currentTime)));
      }
    };

    if ($serverTime.size() > 0) {
      setInterval(updateTime, 1000);
    }

  });

}).call(this);


jQuery(document).ready(function() {
  "use strict";

  // Toggle Left Menu
  jQuery('.leftpanel .nav-parent > a').on('click', function() {

    var parent = jQuery(this).parent();
    var sub = parent.find('> ul');

    // Dropdown works only when leftpanel is not collapsed
    if(!jQuery('body').hasClass('leftpanel-collapsed')) {
      if(sub.is(':visible')) {
        sub.slideUp(200, function(){
          parent.removeClass('nav-active');
          jQuery('.mainpanel').css({height: ''});
          adjustmainpanelheight();
        });
      } else {
        closeVisibleSubMenu();
        parent.addClass('nav-active');
        sub.slideDown(200, function(){
          adjustmainpanelheight();
        });
      }
    }
    return false;
  });

  function closeVisibleSubMenu() {
    jQuery('.leftpanel .nav-parent').each(function() {
      var t = jQuery(this);
      if(t.hasClass('nav-active')) {
        t.find('> ul').slideUp(200, function(){
          t.removeClass('nav-active');
        });
      }
    });
  }

  function adjustmainpanelheight() {
    // Adjust mainpanel height
    var docHeight = jQuery(document).height();
    if(docHeight > jQuery('.mainpanel').height())
      jQuery('.mainpanel').height(docHeight);
  }
  adjustmainpanelheight();


  // Add class everytime a mouse pointer hover over it
  jQuery('.nav-bracket > li').hover(function(){
    jQuery(this).addClass('nav-hover');
  }, function(){
    jQuery(this).removeClass('nav-hover');
  });


  // Menu Toggle
  jQuery('.menutoggle').click(function(){

    var body = jQuery('body');
    var bodypos = body.css('position');

    if(bodypos != 'relative') {

      if(!body.hasClass('leftpanel-collapsed')) {
        body.addClass('leftpanel-collapsed');
        jQuery('.nav-bracket ul').attr('style','');

        jQuery(this).addClass('menu-collapsed');

      } else {
        body.removeClass('leftpanel-collapsed chat-view');
        jQuery('.nav-bracket li.active ul').css({display: 'block'});

        jQuery(this).removeClass('menu-collapsed');

      }
    } else {

      if(body.hasClass('leftpanel-show'))
        body.removeClass('leftpanel-show');
      else
        body.addClass('leftpanel-show');

      adjustmainpanelheight();
    }

  });


});
