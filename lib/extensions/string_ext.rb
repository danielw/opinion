class String
  # def to_html
  #   RedCloth.new(self).to_html
  # end
  
  extend ActionView::Helpers::SanitizeHelper::ClassMethods
end
