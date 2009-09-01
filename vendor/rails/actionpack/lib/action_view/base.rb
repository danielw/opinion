module ActionView #:nodoc:
  class ActionViewError < StandardError #:nodoc:
  end

  # Action View templates can be written in three ways. If the template file has a +.erb+ (or +.rhtml+) extension then it uses a mixture of ERb 
  # (included in Ruby) and HTML. If the template file has a +.builder+ (or +.rxml+) extension then Jim Weirich's Builder::XmlMarkup library is used. 
  # If the template file has a +.rjs+ extension then it will use ActionView::Helpers::PrototypeHelper::JavaScriptGenerator.
  # 
  # = ERb
  # 
  # You trigger ERb by using embeddings such as <% %>, <% -%>, and <%= %>. The <%= %> tag set is used when you want output. Consider the 
  # following loop for names:
  #
  #   <b>Names of all the people</b>
  #   <% for person in @people %>
  #     Name: <%= person.name %><br/>
  #   <% end %>
  #
  # The loop is setup in regular embedding tags <% %> and the name is written using the output embedding tag <%= %>. Note that this
  # is not just a usage suggestion. Regular output functions like print or puts won't work with ERb templates. So this would be wrong:
  #
  #   Hi, Mr. <% puts "Frodo" %>
  #
  # If you absolutely must write from within a function, you can use the TextHelper#concat
  #
  # <%- and -%> suppress leading and trailing whitespace, including the trailing newline, and can be used interchangeably with <% and %>.
  #
  # == Using sub templates
  #
  # Using sub templates allows you to sidestep tedious replication and extract common display structures in shared templates. The
  # classic example is the use of a header and footer (even though the Action Pack-way would be to use Layouts):
  #
  #   <%= render "shared/header" %>
  #   Something really specific and terrific
  #   <%= render "shared/footer" %>
  #
  # As you see, we use the output embeddings for the render methods. The render call itself will just return a string holding the
  # result of the rendering. The output embedding writes it to the current template.
  #
  # But you don't have to restrict yourself to static includes. Templates can share variables amongst themselves by using instance
  # variables defined using the regular embedding tags. Like this:
  #
  #   <% @page_title = "A Wonderful Hello" %>
  #   <%= render "shared/header" %>
  #
  # Now the header can pick up on the @page_title variable and use it for outputting a title tag:
  #
  #   <title><%= @page_title %></title>
  #
  # == Passing local variables to sub templates
  # 
  # You can pass local variables to sub templates by using a hash with the variable names as keys and the objects as values:
  #
  #   <%= render "shared/header", { :headline => "Welcome", :person => person } %>
  #
  # These can now be accessed in shared/header with:
  #
  #   Headline: <%= headline %>
  #   First name: <%= person.first_name %>
  #
  # If you need to find out whether a certain local variable has been assigned a value in a particular render call,
  # you need to use the following pattern:
  #
  #   <% if local_assigns.has_key? :headline %>
  #     Headline: <%= headline %>
  #   <% end %>
  #
  # Testing using <tt>defined? headline</tt> will not work. This is an implementation restriction.
  #
  # == Template caching
  #
  # By default, Rails will compile each template to a method in order to render it. When you alter a template, Rails will
  # check the file's modification time and recompile it.
  #
  # == Builder
  #
  # Builder templates are a more programmatic alternative to ERb. They are especially useful for generating XML content. An +XmlMarkup+ object 
  # named +xml+ is automatically made available to templates with a +.builder+ extension. 
  #
  # Here are some basic examples:
  #
  #   xml.em("emphasized")                              # => <em>emphasized</em>
  #   xml.em { xml.b("emph & bold") }                    # => <em><b>emph &amp; bold</b></em>
  #   xml.a("A Link", "href"=>"http://onestepback.org") # => <a href="http://onestepback.org">A Link</a>
  #   xml.target("name"=>"compile", "option"=>"fast")   # => <target option="fast" name="compile"\>
  #                                                     # NOTE: order of attributes is not specified.
  # 
  # Any method with a block will be treated as an XML markup tag with nested markup in the block. For example, the following:
  #
  #   xml.div {
  #     xml.h1(@person.name)
  #     xml.p(@person.bio)
  #   }
  #
  # would produce something like:
  #
  #   <div>
  #     <h1>David Heinemeier Hansson</h1>
  #     <p>A product of Danish Design during the Winter of '79...</p>
  #   </div>
  #
  # A full-length RSS example actually used on Basecamp:
  #
  #   xml.rss("version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/") do
  #     xml.channel do
  #       xml.title(@feed_title)
  #       xml.link(@url)
  #       xml.description "Basecamp: Recent items"
  #       xml.language "en-us"
  #       xml.ttl "40"
  # 
  #       for item in @recent_items
  #         xml.item do
  #           xml.title(item_title(item))
  #           xml.description(item_description(item)) if item_description(item)
  #           xml.pubDate(item_pubDate(item))
  #           xml.guid(@person.firm.account.url + @recent_items.url(item))
  #           xml.link(@person.firm.account.url + @recent_items.url(item))
  #       
  #           xml.tag!("dc:creator", item.author_name) if item_has_creator?(item)
  #         end
  #       end
  #     end
  #   end
  #
  # More builder documentation can be found at http://builder.rubyforge.org.
  #
  # == JavaScriptGenerator
  #
  # JavaScriptGenerator templates end in +.rjs+. Unlike conventional templates which are used to 
  # render the results of an action, these templates generate instructions on how to modify an already rendered page. This makes it easy to 
  # modify multiple elements on your page in one declarative Ajax response. Actions with these templates are called in the background with Ajax 
  # and make updates to the page where the request originated from.
  # 
  # An instance of the JavaScriptGenerator object named +page+ is automatically made available to your template, which is implicitly wrapped in an ActionView::Helpers::PrototypeHelper#update_page block. 
  #
  # When an .rjs action is called with +link_to_remote+, the generated JavaScript is automatically evaluated.  Example:
  #
  #   link_to_remote :url => {:action => 'delete'}
  #
  # The subsequently rendered +delete.rjs+ might look like:
  #
  #   page.replace_html  'sidebar', :partial => 'sidebar'
  #   page.remove        "person-#{@person.id}"
  #   page.visual_effect :highlight, 'user-list' 
  #
  # This refreshes the sidebar, removes a person element and highlights the user list.
  # 
  # See the ActionView::Helpers::PrototypeHelper::GeneratorMethods documentation for more details.
  class Base
    include ERB::Util

    attr_reader   :finder
    attr_accessor :base_path, :assigns, :template_extension, :first_render
    attr_accessor :controller

    attr_reader :logger, :response, :headers
    attr_internal :cookies, :flash, :headers, :params, :request, :response, :session
    
    attr_writer :template_format
    attr_accessor :current_render_extension

    # Specify trim mode for the ERB compiler. Defaults to '-'.
    # See ERb documentation for suitable values.
    @@erb_trim_mode = '-'
    cattr_accessor :erb_trim_mode

    # Specify whether file modification times should be checked to see if a template needs recompilation
    @@cache_template_loading = false
    cattr_accessor :cache_template_loading

    # Specify whether file extension lookup should be cached, and whether template base path lookup should be cached.
    # Should be +false+ for development environments. Defaults to +true+.
    @@cache_template_extensions = true
    cattr_accessor :cache_template_extensions
    
    # Specify whether RJS responses should be wrapped in a try/catch block
    # that alert()s the caught exception (and then re-raises it). 
    @@debug_rjs = false
    cattr_accessor :debug_rjs
    
    @@erb_variable = '_erbout'
    cattr_accessor :erb_variable
    
    delegate :request_forgery_protection_token, :to => :controller

    @@template_handlers = HashWithIndifferentAccess.new
 
    module CompiledTemplates #:nodoc:
      # holds compiled template code
    end
    include CompiledTemplates

    # Maps inline templates to their method names
    cattr_accessor :method_names
    @@method_names = {}
    # Map method names to the names passed in local assigns so far
    @@template_args = {}

    # Cache public asset paths
    cattr_reader :computed_public_paths
    @@computed_public_paths = {}

    @@template_handlers = {}
    @@default_template_handlers = nil

    class ObjectWrapper < Struct.new(:value) #:nodoc:
    end

    def self.load_helpers #:nodoc:
      Dir.entries("#{File.dirname(__FILE__)}/helpers").sort.each do |file|
        next unless file =~ /^([a-z][a-z_]*_helper).rb$/
        require "action_view/helpers/#{$1}"
        helper_module_name = $1.camelize
        if Helpers.const_defined?(helper_module_name)
          include Helpers.const_get(helper_module_name)
        end
      end
    end

    # Register a class that knows how to handle template files with the given
    # extension. This can be used to implement new template types.
    # The constructor for the class must take the ActiveView::Base instance
    # as a parameter, and the class must implement a #render method that
    # takes the contents of the template to render as well as the Hash of
    # local assigns available to the template. The #render method ought to
    # return the rendered template as a string.
    def self.register_template_handler(extension, klass)
      @@template_handlers[extension.to_sym] = klass
      TemplateFinder.update_extension_cache_for(extension.to_s)
    end

    def self.template_handler_extensions
      @@template_handlers.keys.map(&:to_s).sort
    end

    def self.register_default_template_handler(extension, klass)
      register_template_handler(extension, klass)
      @@default_template_handlers = klass
    end

    def self.handler_class_for_extension(extension)
      (extension && @@template_handlers[extension.to_sym]) || @@default_template_handlers
    end

    register_default_template_handler :erb, TemplateHandlers::ERB
    register_template_handler :rjs, TemplateHandlers::RJS
    register_template_handler :builder, TemplateHandlers::Builder

    # TODO: Depreciate old template extensions
    register_template_handler :rhtml, TemplateHandlers::ERB
    register_template_handler :rxml, TemplateHandlers::Builder

    def initialize(view_paths = [], assigns_for_first_render = {}, controller = nil)#:nodoc:
      @assigns = assigns_for_first_render
      @assigns_added = nil
      @controller = controller
      @logger = controller && controller.logger
      @finder = TemplateFinder.new(self, view_paths)
    end

    # Renders the template present at <tt>template_path</tt>. If <tt>use_full_path</tt> is set to true, 
    # it's relative to the view_paths array, otherwise it's absolute. The hash in <tt>local_assigns</tt> 
    # is made available as local variables.
    def render_file(template_path, use_full_path = true, local_assigns = {}) #:nodoc:
      if defined?(ActionMailer) && defined?(ActionMailer::Base) && controller.is_a?(ActionMailer::Base) && !template_path.include?("/")
        raise ActionViewError, <<-END_ERROR
Due to changes in ActionMailer, you need to provide the mailer_name along with the template name.

  render "user_mailer/signup"
  render :file => "user_mailer/signup"

If you are rendering a subtemplate, you must now use controller-like partial syntax:

  render :partial => 'signup' # no mailer_name necessary
        END_ERROR
      end
      
      template = Template.new(self, template_path, use_full_path, local_assigns)

      begin
        render_template(template)
      rescue Exception => e
        if TemplateError === e
          e.sub_template_of(template.filename)
          raise e
        else
          raise TemplateError.new(template, @assigns, e)
        end
      end
    end
    
    # Renders the template present at <tt>template_path</tt> (relative to the view_paths array). 
    # The hash in <tt>local_assigns</tt> is made available as local variables.
    def render(options = {}, old_local_assigns = {}, &block) #:nodoc:
      if options.is_a?(String)
        render_file(options, true, old_local_assigns)
      elsif options == :update
        update_page(&block)
      elsif options.is_a?(Hash)
        options = options.reverse_merge(:locals => {}, :use_full_path => true)

        if options[:layout]
          path, partial_name = partial_pieces(options.delete(:layout))

          if block_given?
            wrap_content_for_layout capture(&block) do 
              concat(render(options.merge(:partial => "#{path}/#{partial_name}")), block.binding)
            end
          else
            wrap_content_for_layout render(options) do
              render(options.merge(:partial => "#{path}/#{partial_name}"))
            end
          end
        elsif options[:file]
          render_file(options[:file], options[:use_full_path], options[:locals])
        elsif options[:partial] && options[:collection]
          render_partial_collection(options[:partial], options[:collection], options[:spacer_template], options[:locals])
        elsif options[:partial]
          render_partial(options[:partial], ActionView::Base::ObjectWrapper.new(options[:object]), options[:locals])
        elsif options[:inline]
          template = Template.new(self, options[:inline], false, options[:locals], true, options[:type])
          render_template(template)
        end
      end
    end

    # Renders the +template+ which is given as a string as either erb or builder depending on <tt>template_extension</tt>.
    # The hash in <tt>local_assigns</tt> is made available as local variables.
    def render_template(template) #:nodoc:
      handler = template.handler
      @current_render_extension = template.extension

      if handler.compilable?
        compile_and_render_template(handler, template)
      else
        handler.render(template.source, template.locals)
      end
    end

    # Returns true is the file may be rendered implicitly.
    def file_public?(template_path)#:nodoc:
      template_path.split('/').last[0,1] != '_'
    end

    # symbolized version of the :format parameter of the request, or :html by default.
    def template_format
      return @template_format if @template_format
      format = controller && controller.respond_to?(:request) && controller.request.parameters[:format]
      @template_format = format.blank? ? :html : format.to_sym
    end

    private
      def wrap_content_for_layout(content)
        original_content_for_layout = @content_for_layout
        @content_for_layout = content
        returning(yield) { @content_for_layout = original_content_for_layout }
      end

      # Evaluate the local assigns and pushes them to the view.
      def evaluate_assigns
        unless @assigns_added
          assign_variables_from_controller
          @assigns_added = true
        end
      end

      # Assigns instance variables from the controller to the view.
      def assign_variables_from_controller
        @assigns.each { |key, value| instance_variable_set("@#{key}", value) }
      end

      # Render the provided template with the given local assigns. If the template has not been rendered with the provided
      # local assigns yet, or if the template has been updated on disk, then the template will be compiled to a method.
      #
      # Either, but not both, of template and file_path may be nil. If file_path is given, the template
      # will only be read if it has to be compiled.
      #
      def compile_and_render_template(handler, template) #:nodoc:
        # compile the given template, if necessary
        handler.compile_template(template)

        # Get the method name for this template and run it
        method_name = @@method_names[template.method_key]
        evaluate_assigns

        send(method_name, template.locals) do |*name|
          instance_variable_get "@content_for_#{name.first || 'layout'}"
        end
      end
  end
end
