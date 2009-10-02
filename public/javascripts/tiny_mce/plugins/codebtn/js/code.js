CodeDialog = {
  
  insert: function() {
    var content = $('code').value;
    var out2 = tinyMCEPopup.editor.dom.encode(content);
    var out = "<pre>"+out2+"</pre>";

    tinyMCEPopup.execCommand('mceInsertContent', false, out);
//    tinyMCEPopup.editor.selection.setContent(out)
    tinyMCEPopup.close();
  }
  
};