var Flash = {
  // When given an error message, wrap it in a list 
  // and show it on the screen.  This message will auto-hide 
  // after a specified amount of miliseconds
  error: function(message) {
    $('flash-errors').innerHTML = '';
    $('flash-errors').innerHTML = "<li>" + message + "</li>";
    new Effect.Appear('flash-errors', {duration: 0.3});
    setTimeout(Flash.fadeError.bind(this), 5000);
  },

  // Notice-level messages.  See Messenger.error for full details.
  notice: function(message) {
    $('flash-notice').innerHTML = '';
    $('flash-notice').innerHTML = "<li>" + message + "</li>";
    new Effect.Appear('flash-notice', {duration: 0.3});
    setTimeout(Flash.fadeNotice.bind(this), 5000);
  },

  // Responsible for fading notices level messages in the dom    
  fadeNotice: function() {
    new Effect.Fade('flash-notice', {duration: 0.3});
  },

  // Responsible for fading error messages in the DOM
  fadeError: function() {
    new Effect.Fade('flash-errors', {duration: 0.3});
  }
}