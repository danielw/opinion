require 'digest/md5'

module JadedPixel
  module Token    
    def self.included(base)
      #base.extend ClassMethods
            
      base.class_eval do        
        extend ClassMethods
        include InstanceMethods

        class_inheritable_reader :token_column, :token_column_limit
        
        alias_method :create_without_token, :create
        alias_method :create, :create_with_token
      end

    end

    module ClassMethods 
      
      def has_token(column = :token, options = {})
        column_class = columns.find { |c| c.name.to_s == column.to_s }
        raise column_class if column_class.nil?
        write_inheritable_attribute(:token_column, column)
        write_inheritable_attribute(:token_column_limit, options[:limit] || column_class.limit || 32)
      end      
      
    end
    
    
    module InstanceMethods
      def create_with_token #:nodoc:
        
        if token_column          
          md5 = Digest::MD5.hexdigest(Time.now.to_s + attributes.to_a.join)
          send("#{token_column}=", md5[0..token_column_limit-1])
        end

        create_without_token
      end      
    end
  end
end

