;(function() {
  'use strict;';

  var root = this;

  root.reserveRulesFormFunc = function() {
    $(function() {

      var $filterContainer = $("#filter_container");
      var $filterSelect = $("#filter_select");
      var $addFilterButton = $("#add_filter_button");

      var renderFilterPanel = function(filter_type, data) {
        var $filter = $("#filter_template_" + filter_type + ">.panel").clone(false);
        $filter.find('.panel-close').on('click', function() {
          $filter.hide('fast', function() {
            $(this).remove();
          });
          return false;
        });
        if (data !== undefined) {
          $filter.find('[name=filters\\[\\]\\[value\\]]').val(data.value);
          $filter.find('select[name=filters\\[\\]\\[cond\\]]').val(data.cond);
        }
        $filter.appendTo($filterContainer);
      }

      $addFilterButton.on('click', function() {
        var filter_type = $filterSelect.val();
        renderFilterPanel(filter_type);
        return false;
      });

      // init
      var json = $("#redraw_json").val();
      if (json !== "") {
        var redrawData = JSON.parse(json);
        redrawData.forEach(function(filter) {
          renderFilterPanel(filter.attr, filter);
        });
      }

    });
  };

}).call(this);
