module SphinxIndex
  
  module Post
    
    def self.included(base)
      base.is_indexed(
        :fields => [
          :created_at, 
          :title
        ], 
        :include => [
          {:association_name => 'users', :field => 'name', :as => 'author'},
          {:association_name => 'category', :field => 'title', :as => 'category'}
        ],
        :concatenate => [
          {:fields => ['title', 'body'], :as => 'body'}
        ],      
        :delta => true
      )
      
    end
    
  end
  
end