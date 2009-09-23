require 'syslog'
require 'logger'

##
# SyslogLogger is a Logger work-alike that logs via syslog instead of to a
# file.  You can add SyslogLogger to your Rails production environment to
# aggregate logs between multiple machines.
#
# By default, SyslogLogger uses the program name 'rails', but this can be
# changed via the first argument to SyslogLogger.new.
#
# NOTE! You can only set the SyslogLogger program name when you initialize
# SyslogLogger for the first time.  This is a limitation of the way
# SyslogLogger uses syslog (and in some ways, a the way syslog(3) works).
# Attempts to change SyslogLogger's program name after the first
# initialization will be ignored.
#
# = Sample usage with Rails
# 
# == config/environment/production.rb
#
# Add the following lines:
# 
#   require 'production_log/syslog_logger'
#   RAILS_DEFAULT_LOGGER = SyslogLogger.new
#
# == config/environment.rb
#
# In 0.10.0, change this line:
# 
#   RAILS_DEFAULT_LOGGER = Logger.new("#{RAILS_ROOT}/log/#{RAILS_ENV}.log")
#
# to:
#
#   RAILS_DEFAULT_LOGGER ||= Logger.new("#{RAILS_ROOT}/log/#{RAILS_ENV}.log")
#
# Other versions of Rails should have a similar change.
#
# == /etc/syslog.conf
#
# Add the following lines:
# 
#  !rails
#  *.*                                             /var/log/production.log
#
# Then touch /var/log/production.log and signal syslogd with a HUP
# (killall -HUP syslogd, on FreeBSD).
#
# == /etc/newsyslog.conf
#
# Add the following line:
# 
#   /var/log/production.log                 640  7     *    @T00  Z
# 
# This creates a log file that is rotated every day at midnight, gzip'd, then
# kept for 7 days.  Consult newsyslog.conf(5) for more details.
#
# Now restart your Rails app.  Your production logs should now be showing up
# in /var/log/production.log.  If you have mulitple machines, you can log them
# all to a central machine with remote syslog logging for analysis.  Consult
# your syslogd(8) manpage for further details.

class SyslogLogger

    ##
    # Maps Logger warning types to syslog(3) warning types.

    LOGGER_MAP = {
        :unknown => :alert,
        :fatal   => :err,
        :error   => :warning,
        :warn    => :notice,
        :info    => :info,
        :debug   => :debug,
    }

    ##
    # Maps Logger log levels to their values so we can silence.

    LOGGER_LEVEL_MAP = {}

    LOGGER_MAP.each_key do |key|
        LOGGER_LEVEL_MAP[key] = Logger.const_get key.to_s.upcase
    end

    MAXIMUM_LINE_LENGTH = 800

    MAX_LINES_PER_MSG   = 5

    ##
    # Maps Logger log level values to syslog log levels.

    LEVEL_LOGGER_MAP = {}

    LOGGER_LEVEL_MAP.invert.each do |level, severity|
        LEVEL_LOGGER_MAP[level] = LOGGER_MAP[severity]
    end

    ##
    # Builds a logging method for level +meth+.

    def self.log_method(meth)
        eval <<-EOM, nil, __FILE__, __LINE__ + 1
            def #{meth}(message = nil, &block)
                add(#{LOGGER_LEVEL_MAP[meth]}, message, &block)
            end
        EOM
    end

    LOGGER_MAP.each_key do |level|
        log_method level
    end

    def self.log_predicate_method(level)
      eval <<-EOM, nil, __FILE__, __LINE__ + 1
        def #{level}?
          #{LOGGER_LEVEL_MAP[level]} >= @level
        end
      EOM
    end

    # Add predicate methods for each log level
    LOGGER_MAP.each_key do |level|
      log_predicate_method level
    end

    ##
    # Log level for Logger compatibility.

    attr_accessor :level

    ##
    # Tag text to prefix each log line with

    attr_accessor :tag

    ##
    # Fills in variables for Logger compatibility.  If this is the first
    # instance of SyslogLogger, +program_name+ may be set to change the logged
    # program name.
    #
    # Due to the way syslog works, only one program name may be chosen.

    def initialize(program_name = 'rails')
        @level = Logger::DEBUG

        return if defined? SYSLOG
        self.class.const_set :SYSLOG, Syslog.open(program_name)
    end

    ##
    # Almost duplicates Logger#add.  +progname+ is ignored.
    # Hacked to add line breaking and tag/prefix support by
    # Jamis Buck.

    def add(severity, message = nil, progname = nil, &block)
        severity ||= Logger::UNKNOWN
        return true if severity < @level

        message = msg2str(message || block.call)
        
        tag_length = tag ? tag.length + 3 : 0
        break_at = MAXIMUM_LINE_LENGTH - tag_length
        lines = 0

        while message.length > break_at && lines < MAX_LINES_PER_MSG
          part = message[0,break_at]
          message = message[break_at..-1]
          write(severity, part)
          lines += 1
        end

        write(severity, message) if message.length > 0 && lines < MAX_LINES_PER_MSG

        return true
    end

    ##
    # Allows messages of a particular log level to be ignored temporarily.
    #
    # Can you say "Broken Windows"?

    def silence(temporary_level = Logger::ERROR)
        old_logger_level = @level
        @level = temporary_level 
        yield
    ensure
        @level = old_logger_level
    end

    private

    ##
    # Writes the given line to the syslog

    def write(severity, message)
      message = "[#{tag}] #{message}" if tag
      SYSLOG.send LEVEL_LOGGER_MAP[severity], clean(message)
    end

    ##
    # Clean up messages so they're nice and pretty.

    def clean(message)
        message = message.to_s.dup
        message.strip!
        message.gsub!(/%/, '%%') # syslog(3) freaks on % (printf)
        message.gsub!(/\e\[[^m]*m/, '') # remove useless ansi color codes
        return message
    end
    
    def msg2str(msg)
      case msg
      when ::String
        msg
      when ::Exception
        "#{ msg.message } (#{ msg.class })\n" <<
          (msg.backtrace || []).join("\n")
      else
        msg.inspect
      end
    end

end

# vim: ts=4 sts=4 sw=4

