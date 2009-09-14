$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib/'
require 'logger'
require 'rack/bug'

class Example  
  def call(env)
    logger = Logger.new(STDOUT)
    logger.info "called"
    sleep 0.01
    @env = env
    logger.warn "env set"
    [200, {"Content-Type" => "text/html"}, ['<html><body><a href="__rack_bug__/bookmarklet.html">Page with bookmarklet for enabling Rack::Bug</a></body></html>']]
  end
end

use Rack::ContentLength
use Rack::Bug
run Example.new