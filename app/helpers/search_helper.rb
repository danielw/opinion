module SearchHelper

  def highlight_search_result(result)
    highlight(excerpt(h(result.body), params[:q]), params[:q])
  rescue ArgumentError
    truncate(result.body, :length => 100) rescue ''
  end

  def forum_link(forum)
    return link_to forum.title, forum_url(forum) unless forum.nil?
    "unknown forum"
  end
  
  def available_categories
    [['All', ''],['----------', ' '], *Category.find(@category_ids).map { |c| [c.title, c.id] }]
  end

end
