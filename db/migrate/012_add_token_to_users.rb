class AddTokenToUsers < ActiveRecord::Migration
  def self.up
    add_column 'users', 'token', :string, :limit => 32
    
    User.find(:all).each do |user|
      md5 = Digest::MD5.hexdigest(Time.now.to_s + user.attributes.to_a.join)
      user.update_attribute(:token, md5)      
    end
  end

  def self.down
    remove_column 'users', 'token'
  end
end
