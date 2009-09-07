class SphinxQuery
  
  def query(q, options = {})  
    params = { :query => q }
    params[:weights] = { :title => 2.0 }
    
    search = Ultrasphinx::Search.new(params)
    search.excerpt
    search.results
  end
end
  
  
