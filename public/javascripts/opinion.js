Ajax.Responders.register({
  onCreate: function() {
    if (Ajax.activeRequestCount > 0)
      Element.show('spinner');
  },
  onComplete: function() {
    if (Ajax.activeRequestCount == 0)
      Element.hide('spinner');
  }
});

var Opinion = {
  addElement: function(element) {
    new Effect.BlindDown('add-'+element, {duration:0.2});
    Field.focus(element+'-title-input');
  },
  
  cancelAddElement: function(element) {
    new Effect.BlindUp('add-'+element, {duration:0.1});
  },
  
  renameElement: function(id, element) {
    $(element+'-name-'+id).hide();
    $('rename-'+element+'-form-'+id).show();
  },
  
  cancelRenameElement: function(id, element) {
    $('rename-'+element+'-form-'+id).hide();
    $(element+'-name-'+id).show();
  },
  
  removeCategory: function(id) {
    new Ajax.Request('/categories/remove_category/'+ id, {evalScripts:true});
  },

  postComment: function() {
    new Effect.BlindDown('post-comment', {duration:0.2});
    new Effect.ScrollTo('post-comment');
    Field.focus('comment-body');
  },
  
  cancelPostComment: function() {
    new Effect.BlindUp('post-comment', {duration:0.1});
  },
  
  createUser: function() {
    new Effect.BlindDown('create-user', {duration:0.2});
    new Effect.ScrollTo('create-user');
    if($('user_email')) { Field.focus('user_email'); }
  },
  
  toggleTextarea: function(bigger) {
    if(bigger) {
      Element.addClassName('topic_body',"more");
      Element.removeClassName('topic_body',"less");
      Element.hide("more-space");
      Element.show("less-space");
    } else {
      Element.addClassName('topic_body',"less");
      Element.removeClassName('topic_body',"more");
      Element.hide("less-space");
      Element.show("more-space");
    }
  },
  
  togglePair: function(element1, element2) {
    Element.toggle(element1);
    Element.toggle(element2);
  }

}

var Dialog = Class.create();
Dialog.instances = [];
Dialog.close = function() {
  for (var i=0; i < this.instances.length; i++) {  this.instances[i].close();  };
  this.instances.clear();
};

Dialog.prototype = {
  
  initialize: function(name, url) {    
    this.content = $("dialog-content");
    this.overlay = $("dialog-overlay");
    this.name = name;
    
    new Ajax.Updater(this.content, url, {onComplete: this.onAppear.bind(this)} );        
    new Effect.Appear(this.overlay, {duration: 0.5, to: 0.8});        
    
    Dialog.instances.push(this);
  },
  
  onAppear: function() {
    this.content.addClassName(this.name);
    this.content.show();
  },
  
  close: function() {
    this.content.hide();
    this.content.removeClassName(this.name);
    new Effect.Fade(this.overlay, {duration: 0.5});
  }
}

var Gravatar = {
  replaceElement: function(element) {
    Element.replace(element, "<img src=\"http://www.gravatar.com/avatar.php?gravatar_id=" + element.innerHTML + "&size=40\" alt=\"\" />")
  },
    
  replaceAll: function() {
    $$('address.gravatar').each(function(e){
      Gravatar.replaceElement(e);
    });
  }  
}

var Timezone = {
  set : function() {
    var date = new Date();
    var timezone = "timezone=" + -date.getTimezoneOffset() * 60;
    date.setTime(date.getTime() + (1000*24*60*60*1000));
    var expires = "; expires=" + date.toGMTString();
    document.cookie = timezone + expires + "; path=/";
  }
}

Event.observe(window, 'load', function() { Timezone.set(); });
Event.observe(window, 'load', function() { setTimeout(Gravatar.replaceAll, 50) } );