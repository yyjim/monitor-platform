ActionMailer::Base.smtp_settings = {
	:address => "smtp.gmail.com",
	:port => 587,
	:authentication => :plain,
  # :domain => ENV['GMAIL_SMTP_USER'],
  # :user_name => ENV['GMAIL_SMTP_USER'],
  # :password => ENV['GMAIL_SMTP_PASSWORD']
  :domain => 'yy.jim731@gmail.com',
  :user_name => 'yy.jim731@gmail.com',
  :password => '10130731'
}
