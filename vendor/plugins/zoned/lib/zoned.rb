module Zoned
  mattr_reader :server_offset
  @@server_offset = 0 #Time.now.gmtoff
  
  def zoned(date)
    return date unless timezone = controller.send(:cookies)[:timezone]
    date - (server_offset - timezone.to_i)
  end
  alias :z :zoned
end
