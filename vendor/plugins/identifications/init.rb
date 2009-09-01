require 'handle'
require 'token'

ActiveRecord::Base.send :include, JadedPixel::Handle
ActiveRecord::Base.send :include, JadedPixel::Token