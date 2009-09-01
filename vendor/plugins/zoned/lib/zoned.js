var Timezone = {
  set : function() {
    var date = new Date();
    var timezone = "timezone=" + -date.getTimezoneOffset() * 60;
    date.setTime(date.getTime() + (1000*24*60*60*1000));
    var expires = "; expires=" + date.toGMTString();
    document.cookie = timezone + expires + "; path=/";
  }
}
