class RenamePostToTopicId < ActiveRecord::Migration
  def self.up
    rename_column 'attachments', 'post_id', 'topic_id'
  end

  def self.down
    rename_column 'attachments', 'topic_id', 'post_id'
  end
end
