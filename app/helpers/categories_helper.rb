module CategoriesHelper
  def css_class_for(string)
    string.downcase.gsub(' ', '')
  end
end
