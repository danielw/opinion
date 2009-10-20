CodeDialog = {
  
  insert: function() {
    var content = $('code').value;
    var out2 = tinyMCEPopup.editor.dom.encode(content);
    var out = "<p><pre>"+out2+"</pre></p>";

    tinyMCEPopup.execCommand('mceInsertContent', false, out);
//    tinyMCEPopup.editor.selection.setContent(out)
    tinyMCEPopup.close();
  }
  
};