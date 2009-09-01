class DeleteAccountsWithZeroPosts < ActiveRecord::Migration
  def self.up

    transaction do  
      User.find(:all).each do |u|
        u.destroy if u.post_count == 0
      end
    end
    
  end

  def self.down
  end
end
