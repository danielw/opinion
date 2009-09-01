# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def recent_date(date)    
    today = z(Time.now.utc)    
    date  = z(date)
        
    day = if date.to_date == today.to_date
      '<span class="event-today">Today</span>'
    elsif date.to_date == today.to_date - 1
      '<span class="event-yesterday">Yesterday</span>'
    else
      date.strftime("%d. %b")
    end
    
    day
  end
  
  def ifchanged(item)
    if item != @most_recent
      @most_recent = item
      item
    end    
  end

  def title(new_value = nil)
    @title = new_value if new_value
    @title
  end
  
  def crumb(title, link, options = nil)
    @crumbs ||= []
    @crumbs << link_to(title, link, options)
  end
  
  def breadcrumbs
    @crumbs ||= []
    @crumbs.join(" &raquo; ")
  end

  def gravatar_img(email, level)
    require 'digest/md5'
        
    "http://www.gravatar.com/avatar.php?gravatar_id=#{Digest::MD5.hexdigest(email)}&size=40"
  end

  def js_flash_notices
    "Flash.notice('#{flash[:notice]}')" if flash[:notice]
  end

  def js_error_notices
    "Flash.error('#{flash[:error]}')" if flash[:error]
  end
  
  def superuser?
    @user and @user.level >= 1024
  end
  
  def admin?
    @user and @user.level >= 128
  end
  
  def moderator?
    @user and @user.level >= 64
  end
  
  def formatted_date(datetime)
    now = z(Time.now.utc)    
    datetime = z(datetime)
    
    
    if (time_diff = now - datetime) < 86400
      return "Today, #{datetime.strftime('%I:%M%p')}"
    elsif (time_diff = now - datetime) < 172800
      return "Yesterday, #{datetime.strftime('%I:%M%p')}"
    else
      return datetime.strftime("%I:%M%p, %b %d, %G")
    end
  end
  
  def datetime(date)
    return "unknown" if date.nil?
    date.strftime("%Y-%m-%d %I:%M%p")
  end

  def pagination_links(paginator, options={}, html_options={})
    html   = []

    html << if paginator.current.previous 
     content_tag(:span, link_to("&laquo; Previous", params.update(:page => paginator.current.previous) ), :class => 'prev') 
    end

    html << pagination_links_each(paginator, options) do |page|
     html_options[:title] = "Go to Page #{page}"

     link_to(page.to_s, params.update(:page => page), html_options)
    end

    html << if paginator.current.next 
     content_tag(:span, link_to("Next &raquo;", params.update(:page => paginator.current.next) ), :class => 'next') 
    end

    content_tag :div, html.join, :id => 'pagination'
  end
  
  def row_class(name = 'generic')
    variable_name = "@#{name.to_s.downcase.underscore.gsub(/\s/,"_")}_counter"
    counter = instance_variable_get(variable_name)
    counter ||= 0
    counter  += 1
    instance_variable_set(variable_name, counter)
    counter.even? ? "even" : "odd"    
  end
  
  def sig(user)
    "---<br /><p>#{h(user.signature).to_html}</p>" unless user.signature.blank?
  end
  
  def rss_feed_for_page
    if @rss
      "<link rel='alternate' type='application/rss+xml' title='RSS' href='#{@rss}' />"
    else
      ""
    end
  end

end
