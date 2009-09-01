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

class Topic < Post
  belongs_to :user

  has_many :comments, :foreign_key => 'parent_id', :order => 'created_at ASC', :dependent => :destroy
   
  def feed_title
    "#{title} by #{user.name}"
  end 
  
  def topic_id
    id
  end
   
  def author_name
    user.name
  end
  
  def anchor_name
    nil
  end
  
  def editable?
    not closed?
  end
   
  def closed?
    self.status == 'closed'
  end 
  
  def has_admin_post?
    admin_post_id
  end
  
  def admin_post_id
    @admin_post_id ||= connection.select_value(
      "SELECT posts.id FROM posts JOIN users ON users.level >= 128 AND users.id = posts.user_id WHERE posts.parent_id = #{id} OR posts.id = #{id}"
    )
  end
    
  validates_presence_of :user, :message => "Only registered users are allowed to create new topics!"
  validates_presence_of :body
end
