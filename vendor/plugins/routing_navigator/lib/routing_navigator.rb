ActionController::Routing::Route.class_eval do
  # Returns true if the route matches the given filter
  def filtered?(options = {})
    return false unless options.is_a?(Hash)
    filter_diff = options.diff(requirements)
    route_diff  = requirements.diff(options)
    (filter_diff == options) || (filter_diff != route_diff)
  end
end

ActionController::Routing::RouteSet.class_eval do
  def filtered_routes(filter = {})
    routes.reject { |r| r.filtered?(filter) }
  end

  def routes_for_controller(controller_name)
    filtered_routes :controller => controller_name
  end

  def filtered_named_routes(filter = {})
    returning({}) do |accepted_routes|
      named_routes.each { |name, route| accepted_routes[name] = route unless route.filtered?(filter) }
    end
  end
  
  def named_routes_for_controller(controller_name)
    filtered_named_routes :controller => controller_name
  end
end


ActionController::Base.class_eval do
  class_inheritable_reader :routing_navigator_options
  after_filter :append_routing_navigator if RAILS_ENV == 'development'

  # Set what actions the routing navigator after filter is 
  def self.routing_navigator(options = {})
    options = { :off => true } if options == :off
    write_inheritable_hash :routing_navigator_options, options
  end
  
  protected
    def append_routing_navigator
      options = routing_navigator_options || {}
      # yuck!
      return if request.xhr? || options[:off] || (@response.body =~ /<\/body/).nil? ||
        (options[:only] && ![options[:only]].flatten.collect(&:to_s).include?(action_name)) ||
        (options[:except] && [options[:except]].flatten.collect(&:to_s).include?(action_name))
      # yuck!
      old_template_root     = @template.base_path
      begin
        @template.base_path = RoutingNavigatorController.template_root
        @response.body.gsub!(/<\/body/, @template.render(:partial => 'routing_navigator/navigator') + '</body')
      ensure
        @template.base_path = old_template_root
      end
    end
end