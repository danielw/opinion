module JadedPixel
  
  module StringToHandle
    def to_handle
      result = self.downcase

      # strip all non word chars
      result.gsub!(/\W/, ' ')

      # replace all white space sections with a dash
      result.gsub!(/\ +/, '-')

      # trim dashes
      result.gsub!(/(-+)$/, '')
      result.gsub!(/^(-+)/, '')  
      result
    end
  end
  
  String.send(:include, StringToHandle)
  
  module Handle    
    def self.included(base)
      #base.extend ClassMethods
            
      base.class_eval do
        
        extend ClassMethods
        include InstanceMethods

        class_inheritable_reader :handle_column, :handle_options
        

        alias_method :create_without_handle, :create
        alias_method :create, :create_with_handle

        alias_method :update_without_handle, :update
        alias_method :update, :update_with_handle
      end

    end

    module ClassMethods 
      
      def has_handle(column = :handle, options = {})
        write_inheritable_attribute(:handle_column, column)
        write_inheritable_attribute(:handle_options, options)
      end      
      
    end
    
    
    module InstanceMethods
      def create_with_handle #:nodoc:        
        send("#{handle_column}=", compute_handle) if handle_column

        create_without_handle
      end      
      
      def update_with_handle #:nodoc:        
        send("#{handle_column}=", compute_handle) if handle_column and send(handle_column).nil?

        update_without_handle
      end      
      
      private
      
      def compute_handle
        name    = self.class.handle_column        
        source  = self.class.handle_options[:from] || :title
        scope   = self.class.handle_options[:scope]
        
        title = send(source).to_s.to_handle
        
        sql  = "SELECT #{name} FROM #{self.class.table_name} WHERE #{name} LIKE '#{title}%' "
        sql += " AND #{scope} = #{connection.quote(send(scope))} " if scope
        sql += " AND #{self.class.primary_key} <> #{id}" unless new_record?
        
        used = connection.select_values(sql)
        
        next_free_handle(title, used)
      end
      
      def next_free_handle(desired, used)
        count       = desired.scan(/\d+$/).flatten.first.to_i
        base        = desired.gsub(/(-?)\d+$/,'')  
        seperator   = $1 || '-'

        title = count.zero? ? base : "#{base}#{seperator}#{count}"
        
        # increase the count until you find a unused title
        until not used.include?(title) do
          count += 1
          title = "#{base}#{seperator}#{count}"          
        end
        
        title
      end 
    end
  end
end

