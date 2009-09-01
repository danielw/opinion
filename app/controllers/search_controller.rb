class SearchController < ApplicationController

  def posts 
    
    category_ids = Category.ids_matching(access_conditions)
        
    @count = Post.connection.select_value("SELECT COUNT(*) FROM posts WHERE category_id IN (#{category_ids.join(",")}) AND title LIKE '%#{params[:q]}%' OR body LIKE '%#{params[:q]}%'").to_i
    
    @result_pages = Paginator.new(self, @count, 15, params[:page])
    
    @results = Search.query(params[:q], :categories => category_ids, :limit => 15, :page => params[:page])
    render :action => 'results'
  end
end
