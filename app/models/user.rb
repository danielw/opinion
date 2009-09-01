# == Schema Information
# Schema version: 32
#
# Table name: users
#
#  id        :integer(11)   not null, primary key
#  password  :string(255)   
#  name      :string(255)   
#  email     :string(255)   
#  url       :string(255)   
#  level     :integer(11)   
#  token     :string(32)    
#  title     :string(255)   
#  signature :text          
#

class User < ActiveRecord::Base
  has_many :posts, :dependent => :destroy
  has_token :token

  attr_protected :level, :title


  cattr_accessor :levels
  self.levels = {
    1024 => "Super User",
    128  => "Administrator",
    64   => "Moderator",
    0    => "Member"
  }
  
  def self.auth(email, password)
    find_by_email_and_password(email, password)
  end
    
  def level_title
    levels[level] || 'Member'
  end
  
  def moderator?
    self.level >= 64
  end
  
  def admin?
    self.level >= 128
  end
  
  def superuser?
    self.level >= 1024
  end
  
  def url=(value)
    case value
    when nil, (value.empty?), /^(http|ssh|ed2k|feed|https|ftp|telnet|sftp)\:\/\//
      super
    else
      super('http://' +value)
    end
  end
  
  def post_count
    connection.select_value("SELECT COUNT(*) FROM posts WHERE user_id = #{self.id}").to_i
  end
  
  def title
    self[:title].blank? ? level_title : self[:title]     
  end
    
  private
      
  validates_uniqueness_of :email, :name
  validates_presence_of :name
  validates_presence_of :email
  validates_presence_of :password
  validates_format_of :email, :with => /.*?\@.*\..{2,4}/
  validates_length_of :password, :minimum => 5, :message => "is too short (min 5 characters)"
  validates_confirmation_of :password, :message => "password and confirmed password do not match!"  
end
