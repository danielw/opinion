module SphinxIndex
  
  module Post
    
    def self.included(base)
      base.is_indexed(
        :fields => [           
          'title',
          'body',
          'category_id',
          'created_at'
        ], 
        :include => [
          {:association_name => 'user', :field => 'name', :as => 'author'},
          {:association_name => 'category', :field => 'title', :as => 'category'}
        ],
        :delta => true
      )
      
    end
    
  end
  
end