/**
 * $Id: editor_plugin_src.js 677 2008-03-07 13:52:41Z spocke $
 *
 * @author Moxiecode
 * @copyright Copyright © 2004-2008, Moxiecode Systems AB, All rights reserved.
 */

(function() {
	tinymce.create('tinymce.plugins.CodebtnPlugin', {
		init : function(ed, url) {
		  
			// Register commands
			ed.addCommand('codeBtn', function() {
				ed.windowManager.open({
					file : url + '/code.html',
					width : 600,
					height : 500,
					inline : 1
				}, {
					plugin_url : url
				});			  
			});

			// Register buttons
			ed.addButton('codebtn', {
				title : 'Insert Source Code',
				image: '/javascripts/tiny_mce/plugins/codebtn/icon.png',
				cmd : 'codeBtn'
			});
		},

		getInfo : function() {
			return {
				longname : 'Advanced image',
				author : 'Moxiecode Systems AB',
				authorurl : 'http://tinymce.moxiecode.com',
				infourl : 'http://wiki.moxiecode.com/index.php/TinyMCE:Plugins/advimage',
				version : tinymce.majorVersion + "." + tinymce.minorVersion
			};
		}
	});

	// Register plugin
	tinymce.PluginManager.add('codebtn', tinymce.plugins.CodebtnPlugin);
})();