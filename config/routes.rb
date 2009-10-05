ActionController::Routing::Routes.draw do |map|
  
  map.index     '', :controller => 'forums'
  map.accounts  'accounts/:action/:id', :controller => "accounts"
  map.users     'users/:action/:id', :controller => "users"
  map.admin     'admin/:action/:id', :controller => "admin"
  # map.navigator 'routing_navigator/:action', :controller => "routing_navigator", :action => 'index'

  map.feed       'feed', :controller => 'dashboard', :action => 'feed'

  map.resources :forums  
  map.resources :categories, :member => { :rename => :put } do |categories|
    categories.resources :posts do |posts|
      posts.resource :images
    end
  end  
  
  # Legacy routes to catch old links, e.g. http://forums.shopify.com/community/general/post/2672
  map.connect   'community', :controller => 'legacy_routes', :action => 'area', :id => 1
  map.connect   'community/general', :controller => 'legacy_routes', :action => 'category', :id => 1
  map.connect   'community/design', :controller => 'legacy_routes', :action => 'category', :id => 2
  map.connect   ':area/:category/post/:id', :controller => 'legacy_routes', :action => 'post'

  map.connect   ':controller/:action/:id', :action => 'index', :id => nil
end
