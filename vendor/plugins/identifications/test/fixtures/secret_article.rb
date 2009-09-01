class SecretArticle < ActiveRecord::Base

  has_token :token
end