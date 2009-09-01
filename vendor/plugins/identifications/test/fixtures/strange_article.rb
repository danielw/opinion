class StrangeArticle < ActiveRecord::Base
  
  has_handle :handle, :from => :name
end