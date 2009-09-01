class SqlLikeQuery

  def query(q, options = {})  
    query = "%#{q}%"
    
    page = options[:page] || 0
    limit = options[:limit] || 20
    
    sql = "(title LIKE ? OR body LIKE ?)"
    params = [query, query]
    
    if categories = options[:categories]
      sql << " AND category_id IN (#{categories.join(",")}) "
    end    
        
    if forum = options[:forum]
      forum_id = forum.is_a?(ActiveRecord::Base) ? forum.id : forum.to_i
      sql << " AND forum_id = #{forum_id}"
    end
    
    offset = options[:page] ? (page.to_i - 1) * limit.to_i : 0
              
    Post.find(:all, 
              :conditions => [sql, *params],
              :order => 'created_at DESC',
              :limit => limit, 
              :offset => offset)                      
  end
  
  def rebuild_index
  end
  
  def index_post(post)      
  end    
  
end
