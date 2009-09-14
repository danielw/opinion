class SearchController < ApplicationController

  def posts     
    @category_ids = Category.ids_matching(access_conditions)            
            
    # Restrict search down to a single category but only if it's actually a 
    # valid one for this user.     
    search_categories = if params[:category] and @category_ids.include?(params[:category].to_i)
      [params[:category].to_i]
    else
      @category_ids
    end
          
    @results, @search = SphinxQuery.search(params[:q], :author => params[:author], :categories => search_categories, :limit => 20, :page => params[:page])
    render :action => 'results'
  end
end
