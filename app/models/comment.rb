# == Schema Information
# Schema version: 32
#
# Table name: posts
#
#  id          :integer(11)   not null, primary key
#  category_id :integer(11)   
#  title       :string(255)   
#  body        :text          
#  body_html   :text          
#  user_id     :integer(11)   
#  created_at  :datetime      
#  type        :string(255)   
#  parent_id   :integer(11)   
#  forum_id    :integer(11)   
#  updated_at  :datetime      
#  status      :string(255)   default("normal")
#  edited_at   :datetime      
#

class Comment < Post
  belongs_to :topic, :foreign_key => 'parent_id', :touch => true
  
  def feed_title
    "#{author_name} commented on #{topic.title}"
  end

  def editable?
    return false if self.topic.closed?
    self.created_at > 3.days.ago
  end
  
  def topic_id
    parent_id
  end
  
  def topic_title
    topic.title
  end
  
  def author_name
    user ? user.name : "Unknown User"
  end
  
  def anchor_name
    "comment-#{id}"
  end
  
  validates_presence_of :body
end
