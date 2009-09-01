require 'recaptcha.rb'

ActionView::Base.send :include, ReCaptcha::Helper
ActionController::Base.send :include, ReCaptcha::Controller