class RoutingNavigatorController < ActionController::Base
  routing_navigator :off if respond_to? :routing_navigator
  self.template_root = File.join(RAILS_ROOT, 'vendor/plugins/routing_navigator/views')
  
  def index
    @filter = YAML.load(params[:filter].to_s).symbolize_keys rescue nil
  end
  
  def recognize_url
    render :text => ::ActionController::Routing::Routes.recognize_path(params[:path]).inspect, :layout => false
  end
  
  def generate_route
    render :text => ::ActionController::Routing::Routes.generate(YAML.load(params[:options]).symbolize_keys).inspect, :layout => false
  end
end