# == Schema Information
# Schema version: 32
#
# Table name: forums
#
#  id              :integer(11)   not null, primary key
#  title           :string(255)   
#  anonymous_posts :boolean(1)    
#  body            :text          
#

class Forum < ActiveRecord::Base
  has_many :categories, :dependent => :destroy
  has_many :posts
  
  protected
  
  validates_presence_of :title
  validates_uniqueness_of :title
end
