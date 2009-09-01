module PostsHelper

  def allowed_to_post?
    if !@user and !@topic.forum.anonymous_posts
      return false
    end
    true
  end

end
