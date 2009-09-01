module Search
  mattr_accessor :engine
  @@engine = SqlLikeQuery.new
  
  def self.query(string, options = {})
    Search.engine.query(string, options)
  end
end