/**
 * Add trailing element while editing, to enable placing the cursor at the end of the body.
 *
 * Author: Thomas Andersen (tan) <tan@enonic.com>
 * Thanks to: Mariusz Pękala (Arsen7) <skoot@qi.pl>
 */
(function() {
        tinymce.create('tinymce.plugins.Trailing', {
                init : function(ed, url) {
                        var t = this;
                        ed.onSetContent.add( function(ed,o) {
                                t._insertTrailingElement(ed);
                        });
                        ed.onNodeChange.add( function(ed, cm, e) {
                                t._insertTrailingElement(ed);
                        });
                        ed.onBeforeGetContent.add( function(ed, o) {
                                t._removeTrailingElement(ed);
                        });
                },

                getInfo : function() {
                        return {
                                longname : 'Trailing Element Fix',
                                author : 'tan@enonic, m.pekala@idelfi.com',
                                authorurl : 'http://enonic.com, http://idelfi.com',
                                infourl : 'http://enonic.com, http://idelfi.com/tiny_mce/trailing_plugin.html',
                                version : '1.0'
                        };
                },

                /* Private methods */

                _insertTrailingElement : function(ed) {
                        var body = ed.getBody();
                        var lc = body && body.lastChild;
                        var fc = body && body.firstChild;

                        if(!body || !lc || !fc)
                                return;
                        try {
                                if( lc.nodeType == 1 && lc.nodeName.toLowerCase() != 'p' && (!lc.innerHTML.match(/^(\s|<br\s*\/?>|&nbsp;)*$/i) || !lc.firstChild) ) {
                                        body.appendChild( ed.dom.create('p',{},'<br/>') );
                                }
                                if( fc.nodeType == 1 && fc.nodeName.toLowerCase() != 'p' && (!fc.innerHTML.match(/^(\s|<br\s*\/?>|&nbsp;)*$/i) || !fc.firstChild) ) {
                                        body.insertBefore( ed.dom.create('p',{},'<br/>') , fc);
                                }
                        } catch(err) {
                                if( typeof(console) == 'object' && console.error )
                                        console.error("TrailingPlugin._insertTrailingElement (ignored) : " + err);
                        }
                },

                _removeTrailingElement : function(ed) {
                        var body = ed.getBody();
                        if(!body)
                                return;
                        var last, limit_l = 1, first, limit_f = 1;
                        try {
                                while( (last = body.lastChild) && last.nodeType == 1 && last.nodeName.toLowerCase() == 'p' &&
                                                last.innerHTML.match(/^(\s|<br\s*\/?>|&nbsp;)*$/i) ) {
                                        body.removeChild(last);
                                        if(limit_l-- < 1)
                                                break;
                                }
                                while( (first = body.firstChild) && first.nodeType == 1 && first.nodeName.toLowerCase() == 'p' &&
                                                first.innerHTML.match(/^(\s|<br\s*\/?>|&nbsp;)*$/i) ) {
                                        body.removeChild(first);
                                        if(limit_f-- < 1)
                                                break;
                                }
                        } catch(err) {
                                if( typeof(console) == 'object' && console.error )
                                        console.error("TrailingPlugin._removeTrailingElement (ignored) : " + err);
                        }
                }
        });

        tinymce.PluginManager.add('trailing', tinymce.plugins.Trailing);
})();
