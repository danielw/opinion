CodeDialog = {
  
  insert: function() {
    var content = $('code').value;
    var out2 = tinyMCEPopup.editor.dom.encode(content);
    var out = "<code>"+out2+"</code>";

    tinyMCEPopup.execCommand('mceInsertContent', false, out);
//    tinyMCEPopup.editor.selection.setContent(out)
    tinyMCEPopup.close();
  }
  
};