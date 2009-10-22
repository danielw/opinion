tinyMCE.init({
  theme:"advanced",
  mode:"exact",
  elements: "comment_body",
  plugins: "safari,codebtn,inlinepopups,trailing",

  dialog_type : "modal",
  theme_advanced_buttons1 : "bold,italic,bullist,numlist, blockquote, image,|,link, unlink, |,codebtn" ,
  theme_advanced_buttons2 : "",
  theme_advanced_buttons3 : "",
  gecko_spellcheck : true,
  theme_advanced_toolbar_location : "top",
  theme_advanced_toolbar_align : "left",
  theme_advanced_statusbar_location : "bottom",
  theme_advanced_resizing : true,
  theme_advanced_path : false,
  theme_advanced_resizing_max_width : 620
});