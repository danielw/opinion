require "rack/bug/panels/log_panel/logger_extension"

module Rack
  module Bug
    
    class LogPanel < Panel
      
      LEVELS = [:debug, :info, :warn, :error, :fatal, :unknown]
      
      def self.record(message, severity)
        return unless Rack::Bug.enabled?
        @start_time ||= Time.now
        call_stack = caller
        if defined?(Rails) && Rails.backtrace_cleaner
          call_stack = Rails.backtrace_cleaner.clean(call_stack)
        else
          call_stack = call_stack.slice(2,2)
        end
        logs << {:severity => severity, :message => message, :call_stack => call_stack, :time => ((Time.now - @start_time) * 1000).to_i}
      end
      
      def self.reset
        Thread.current["rack.bug.logs"] = []
      end
      
      def self.logs
        Thread.current["rack.bug.logs"] ||= []
      end
      
      def name
        "log"
      end
      
      def heading
        "Log"
      end

      def content
        result = render_template "panels/log", :logs => self.class.logs
        self.class.reset
        return result
      end
      
    end
    
  end
end
