require 'html_engine'
require 'html_engine_ext'

HtmlEngine.default = :textile
HtmlEngine.register(:textile) { |text| RedCloth.new(text, [:hard_breaks] ).to_html }
HtmlEngine.register(:filtering_textile) { |text| RedCloth.new(text, [:hard_breaks, :filter_html, :filter_styles] ).to_html }

begin
  rails_filters = Class.new do 
    def self.white_list_sanitizer
      @white_list_sanitizer ||= HTML::WhiteListSanitizer.new
    end
    
    include ActionView::Helpers::TextHelper 
    include ActionView::Helpers::TagHelper 
    include ActionView::Helpers::SanitizeHelper     
  end.new

  HtmlEngine.register(:autolink) { |text| rails_filters.auto_link(text) }  
  HtmlEngine.register(:sanitize) { |text| rails_filters.sanitize(text) }    
  HtmlEngine.register(:simple)   { |text| rails_filters.simple_format(text) }    
  
  HtmlEngine.register(:whitelist_html) do |html| 
    if html.index("<")
      tokenizer = HTML::Tokenizer.new(html)
      new_text = []
      
      while token = tokenizer.next
        node = HTML::Node.parse(nil, 0, 0, token, false)
        new_text << if not node.is_a? HTML::Tag or HtmlEngine::ERLAUBT_TAGS.include?(node.name)
          node.to_s
        else
          node.to_s.gsub(/</, "&lt;").gsub(/>/, "&gt;")
        end          
      end
    
      new_text.to_s 
    else
      html
    end
  end
  
end
