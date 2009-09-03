require 'html_engine'
require 'html_engine_ext'
require 'red_cloth_patches'

HtmlEngine.default = :textile
HtmlEngine.register(:textile) { |text| RedCloth.new(text, [:hard_breaks] ).to_html }
HtmlEngine.register(:filtering_textile) { |text| RedCloth.new(text, [:hard_breaks, :filter_html, :filter_styles] ).to_html }

begin
  rails_filters = Class.new do 
    include ActionView::Helpers::TextHelper 
    include ActionView::Helpers::TagHelper 
    include ActionView::Helpers::SanitizeHelper 
  end.new

  HtmlEngine.register(:autolink) { |text| rails_filters.auto_link(text) }  
  HtmlEngine.register(:sanitize) { |text| rails_filters.sanitize(text) }    
  HtmlEngine.register(:simple)   { |text| rails_filters.simple_format(text) }    
  
  ERLAUBT_TAGS = ['pre', 'code', 'img', 'a', 'strong', 'em', 'span', 'b', 'br', 'i', 'p', 'embed', 'object', 'blockquote', 'ul', 'ol', 'li', 'h1', 'h2', 'h3', 'h4', 'h5']
  
  HtmlEngine.register(:whitelist_html) do |html| 
    HTML::WhiteListSanitizer.new.sanitize(html, :tags => ERLAUBT_TAGS, :attributes => [])
    # if html.index("<")
    #   tokenizer = HTML::Tokenizer.new(html)
    #   new_text = []
    #   
    #   while token = tokenizer.next
    #     node = HTML::Node.parse(nil, 0, 0, token, false)
    #     new_text << if not node.is_a? HTML::Tag or ERLAUBT_TAGS.include?(node.name)
    #       node.to_s
    #     else
    #       node.to_s.gsub(/</, "&lt;").gsub(/>/, "&gt;")
    #     end          
    #   end
    # 
    #   new_text.to_s 
    # else
    #   html
    # end
  end
  
end
