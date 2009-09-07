module LoggerExtensions
  def self.included(target)
    target.send :alias_method, :add_without_rack_bug, :add
    target.send :alias_method, :add, :add_with_rack_bug
  end
  
  def add_with_rack_bug(*args, &block)
    logged_message = add_without_rack_bug(*args, &block)
    Rack::Bug::LogPanel.record(args[1] || args[2], args[0])
    return logged_message
  end
end

if defined?(Rack::Bug::LoggerClass)
  logger_klass = Rack::Bug::LoggerClass
elsif defined?(ActiveSupport::BufferedLogger)
  logger_klass = ActiveSupport::BufferedLogger
elsif defined?(Logger)
  logger_klass = Logger
end

logger_klass.send :include, LoggerExtensions if logger_klass