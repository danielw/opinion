module SphinxQuery
  
  def self.search(q, options = {})  
    params = { :query => q }
    params[:weights]  = { :title => 1.5 }
    params[:per_page] = options[:limit]                         if options[:limit]
    params[:page]     = options[:page]                          if options[:page]
    params[:filters]  = {}
    params[:filters]['category_id'] = options[:categories]      if options[:categories]
    params[:filters]['author']      = options[:author]          if options[:author]    
          
    @search = Ultrasphinx::Search.new(params)
    @search.excerpt
    return @search.results, @search
  end
end
  
  
