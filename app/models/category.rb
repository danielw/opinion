# == Schema Information
# Schema version: 32
#
# Table name: categories
#
#  id           :integer(11)   not null, primary key
#  title        :string(255)   
#  forum_id     :integer(11)   
#  body         :text          
#  body_html    :text          
#  subtitle     :string(255)   
#  access_level :integer(11)   default(0)
#

class Category < ActiveRecord::Base
  belongs_to :forum
  before_save :transform_text
  attr_protected :forum
  has_many :topics, :dependent => :destroy
  has_many :posts
  
  def self.ids_matching(conditions)
    Category.find(:all, :conditions => conditions, :select => 'id' ).collect(&:id)
  end

  def title
    super
  end

  # This will transform the original text to html output with tags using a filter
  # like Redcloth
  def transform_text
    self.body_html = body.to_html if self.body
  end

  validates_uniqueness_of :title, :scope => :forum_id
  validates_presence_of :title
end
