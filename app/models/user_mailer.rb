class UserMailer < ActionMailer::Base
  HOST = 'http://monitorplatform.heroku.com/'
  
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Please activate your new account'
    @body[:url]  = "#{HOST}activate/#{user.activation_code}"
  end
  
  def activation(user)
    setup_email(user)
    @subject    += 'Your account has been activated!'
    @body[:url]  = "#{HOST}"
  end
  
  protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = "monitorplatform@gmail.com"
      @subject     = "[Monitor Platform]"
      @sent_on     = Time.now
      @body[:user] = user
    end
end
