# This module contains methods for transforming text into valid xhtml. 
# Different modules can be registered using the register method
# By default textile is used as transformation engine
module HtmlEngine
  
  # Access a hash of all supported engines
  mattr_accessor :supported_engines
  @@supported_engines = {}
  
  # Default transformation
  mattr_accessor :default
  @@default = :textile
  
  # Register a new engine. Expects a name as symbol and a block which does 
  # transformation
  #
  #   HtmlEngine.register(:markdown) { |text| BlueCloth.new(text).to_html }
  def self.register(engine, &block)
    supported_engines[engine] = Proc.new(&block)
  end
  
  # Is the following engine supported?  
  def self.supported?(engine)
    not supported_engines[engines].nil?
  end

  # Transform the given source to html 
  # the options hash taks following parameters
  #
  def self.transform(source, *engines)
    return '' if source.blank?
        
    engine_chain = [engines].flatten.compact
    engine_chain = [HtmlEngine.default].flatten if engine_chain.blank?
    
    begin
      engine_chain.inject(source) do |text, engine|
        if engine = supported_engines[engine]
          engine.call(text)
        else
          text
        end
      end
    rescue => e
      "Transformation error in engine(s): #{engines.join(" ")} -- #{e.message}"
    end    
  end
end