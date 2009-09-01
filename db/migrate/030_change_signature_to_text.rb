class ChangeSignatureToText < ActiveRecord::Migration
  def self.up
    change_column 'users', 'signature', :text
  end

  def self.down
    change_column 'users', 'signature', :string
  end
end
