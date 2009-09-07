module Search
  mattr_accessor :engine
  @@engine = SphinxQuery.new
  
  def self.query(string, options = {})
    Search.engine.query(string, options)
  end
end