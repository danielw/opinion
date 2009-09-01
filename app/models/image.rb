# == Schema Information
# Schema version: 32
#
# Table name: images
#
#  id           :integer(11)   not null, primary key
#  parent_id    :integer(11)   
#  post_id      :integer(11)   
#  content_type :string(255)   
#  filename     :string(255)   
#  thumbnail    :string(255)   
#  size         :integer(11)   
#  width        :integer(11)   
#  height       :integer(11)   
#

class Image < ActiveRecord::Base
  has_attachment :content_type => :image, 
                 :storage => :file_system, 
                 :size => 0..1.megabyte,
                 :resize_to => '640x480>',
                 :path_prefix => 'public/files',
                 :thumbnails => { :thumb => '150x150>' }

  validates_as_attachment
end
