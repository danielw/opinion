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

class Post < ActiveRecord::Base
  before_save :transform_text, :replace_empty_title
  belongs_to  :user
  belongs_to  :forum
  belongs_to  :category
  has_many :images, :conditions => 'parent_id IS NULL'
  
  attr_protected :forum
  
  def topic_title
    title
  end

  def owner?(current_user)
    self.user != nil and self.user == current_user
  end

  def is_topic?
    self.class == Topic
  end

  def is_comment?
    self.class == Comment
  end

  private 
  
  # Replaces an empty title with 'untitled'
  def replace_empty_title
    if self.title == ''
      self.title = "untitled"
    end
  end
  
  # This will transform the original text to html output with tags using a filter
  # like Redcloth
  def transform_text
    self.body_html = body.to_html
  end
  
end
