jQuery.noConflict();
jQuery(function() {
  jQuery.rackBug = function(data, klass) {
    jQuery.rackBug.init();
  };
  jQuery.extend(jQuery.rackBug, {
    init: function() {
      var current = null;
      jQuery('#rack_bug ul.panels li a').click(function() {
        current = jQuery('#rack_bug #' + this.className);
        
        if (current.is(':visible')) {
          jQuery(document).trigger('close.rackBug');
        } else {
          jQuery('#rack_bug .panel_content').hide();
          current.show();
          jQuery.rackBug.open();
        }
        return false;
      });
      jQuery('#rack_bug a.remote_call').click(function() {
        jQuery('#rack_bug_debug_window').load(this.href, null, function() {
          jQuery('#rack_bug_debug_window a.back').click(function() {
            jQuery(this).parent().hide();
            return false;
          });
        });
        jQuery('#rack_bug_debug_window').show();
        return false;
      });
      jQuery('#log_nav a').click(function() {
        jQuery('#log table.log_table').hide();
        jQuery('#log_table_' + this.hash.replace('#','')).show();
      });
      jQuery('#rack_bug a.reveal_backtrace').click(function() {
        jQuery(this).parents("tr").next().toggle();
        return false;
      });
      jQuery('#rack_bug a.rack_bug_close').click(function() {
        jQuery(document).trigger('close.rackBug');
        return false;
      });
    },
    open: function() {
      jQuery(document).bind('keydown.rackBug', function(e) {
        if (e.keyCode == 27) {
          jQuery.rackBug.close();
        }
      });
    },
    toggle_content: function(elem) {
      if (elem.is(':visible')) {
        elem.hide();
      } else {
        elem.show();
      }
    },
    close: function() {
      jQuery(document).trigger('close.rackBug');
      return false;
    }
  });
  jQuery(document).bind('close.rackBug', function() {
    jQuery(document).unbind('keydown.rackBug');
    jQuery('.panel_content').hide();
  });
});

jQuery(function() {
  jQuery.rackBug();
});