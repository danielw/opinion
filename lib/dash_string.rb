class String
  # Converts a post title to its-title-using-dashes
  # All special chars are stripped in the process  
  def dashed
    result = self.downcase
  
    # strip all non word chars
    result.gsub!(/\W/, ' ')
  
    # replace all white space sections with a dash
    result.gsub!(/\ +/, '-')
  
    # trim dashes
    result.gsub!(/(-)$/, '')
    result.gsub!(/^(-)/, '')  
    result
  end
end