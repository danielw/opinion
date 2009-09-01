class UserMailer < ActionMailer::Base

  def recover(user, hostname, sent_at = Time.now)
    @from       = "Opinion Forum <opinion@#{hostname}>"
    @subject    = "Password retrieval"
    @recipients = user.email
    @headers    = {}
    @sent_on    = sent_at
    
    @body['user'] = user
  end


end
