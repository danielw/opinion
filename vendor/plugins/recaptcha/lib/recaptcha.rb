# ReCAPTCHA
module ReCaptcha
  RECAPTCHA_API_SERVER        = 'http://api.recaptcha.net';
  RECAPTCHA_API_SECURE_SERVER = 'https://api-secure.recaptcha.net';
  RECAPTCHA_VERIFY_SERVER     = 'api-verify.recaptcha.net';
  
  mattr_accessor :public_key
  self.public_key = nil
  
  mattr_accessor :private_key
  self.private_key = nil

  module Helper
    # Your public API can be specified in the +options+ hash or preferably the environment
    def recaptcha_tags(options = {})
      return if ReCaptcha.public_key.nil?
      
      # Default options
      key   = options[:public_key] ||= ReCaptcha.public_key
      error = options[:error] ||= session[:recaptcha_error]
      uri   = options[:ssl] ? RECAPTCHA_API_SECURE_SERVER : RECAPTCHA_API_SERVER
      xhtml = Builder::XmlMarkup.new :target => out=(''), :indent => 2 # Because I can.
      if options[:display] 
        xhtml.script(:type => "text/javascript"){ xhtml.text! "var RecaptchaOptions = #{options[:display].to_json};\n"}
      end
      xhtml.script(:type => "text/javascript", :src => "#{uri}/challenge?k=#{key}&error=#{error}") {}
      unless options[:noscript] == false
        xhtml.noscript do
          xhtml.iframe(:src => "#{uri}/noscript?k=#{key}",
                       :height => options[:iframe_height] ||= 300,
                       :width  => options[:iframe_width]  ||= 500,
                       :frameborder => 0) {}; xhtml.br
          xhtml.textarea(:name => "recaptcha_challenge_field", :rows => 3, :cols => 40) {}
          xhtml.input :name => "recaptcha_response_field",
                      :type => "hidden", :value => "manual_challenge"
        end
      end
      raise ReCaptchaError, "No public key specified." unless key
      return out
    end # recaptcha_tags
  end # Helpers
  
  module Controller
    # Your private API key must be specified in the environment variable +RECAPTCHA_PRIVATE_KEY+
    def verify_recaptcha(model = nil)
      if ReCaptcha.private_key.nil?
        logger.warn "Skipping captcha check, no private key specified."
        return
      end
      begin
        recaptcha = Net::HTTP.post_form URI.parse("http://#{RECAPTCHA_VERIFY_SERVER}/verify"), {
          :privatekey => ReCaptcha.private_key,
          :remoteip   => request.remote_ip,
          :challenge  => params[:recaptcha_challenge_field],
          :response   => params[:recaptcha_response_field]
        }
        answer, error = recaptcha.body.split.map(&:chomp)
        unless answer == 'true'
          session[:recaptcha_error] = error
          model.errors.add_to_base "Captcha response is incorrect, please try again." if model
          return false
        else
          session[:recaptcha_error] = nil
          return true
        end
      rescue Exception => e
        raise ReCaptchaError, e
      end    
    end # verify_recaptcha
  end # ControllerHelpers

  class ReCaptchaError < StandardError; end
  
end
