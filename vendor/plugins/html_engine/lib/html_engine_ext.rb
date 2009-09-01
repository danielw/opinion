# We will extend the string class so that we can easily access the transformations
# this is a great example of bottom up programming. We extend ruby to be tailor made
# for the application we write in our little world
class String
  
  # to_html will transform the string to html. 
  # different engines are supported. By default textile transformation will be used
  #
  # Example:
  #
  #   "Hello **world**".to_html # => "<p>Hello <b>world</b></p>"
  #   "Hello **world**".to_html :textile # => "<p>Hello <b>world</b></p>"
  #
  # You can register more syntax engines by submitting a block to the HtmlEngine 
  # 
  #   HtmlEngine.register(:markdown) { |text| BlueCloth.new(text).to_html }
  # 
  # You can also chain engines behind one and another like this
  #
  #  "Hello <b>world</b>".to_html(:filter_html, :textile) # => "<p>Hello world</p>"
  def to_html(*engines)
    HtmlEngine.transform(self, engines)
  end
end
