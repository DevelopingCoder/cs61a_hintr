require 'securerandom'

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def send_email()
    # assuming the user has been created,
    # sends an email to the user's email with username and password
    require 'mail'
    
    Mail.defaults do
      delivery_method :smtp, {
        :address => 'smtp.gmail.com',
        :port => '587',
        :user_name => 'hintr.app.noreply@gmail.com',
        :password => 'hintrapp169',
        :authentication => :plain,
        :enable_starttls_auto => true
      } 
    end
    user = self
    mail = Mail.new do
      from     'do-not-reply@hintr.app.com'
      to       user.email
      # to       'jaysid95@berkeley.edu'
      subject  'Welcome to cs61a Hintr!'
      
      text_part do
        body  "Welcome to hintr!\n" + 
              "Your login is: " + user.email + "\n" + 
              "Your password is: " + user.password + "\n" + 
              "Make sure to change your password and set your name when you first log in.\n"+
              "Login at: https://cs61a-hintr.herokuapp.com"
      end
      
    end
    mail.deliver!
  end
  
  def add_email(email, name = '')
    # takes in an email and optional name param
    # returns success of user creation
    
    password = SecureRandom.urlsafe_base64(6)
    if User.find_by_email(email)
      return "Email already exists in database"
    end
    # Check if email is already being used
    user = User.create({:name=>name, :email => email, :password => password})
    if user.id
      #send the email
      return "Email invite has been sent"
    else
      return "User creation was not successful"
    end
  end
  
  def delete_email(email)
    if email == self.email
      return "User cannot delete self"
    end
    user = User.find_by_email(email)
    if user
      if User.destroy(user) 
        return "User successfully deleted"
      else
        return "User failed to be deleted"
      end
    else
      return "User never existed"
    end
  end
  
  def delete_emails(emails)
    notice = "Successfully deleted:"
    emails.each do |email|
      if delete_email(email) == "User successfully deleted"
        notice += " " + email
      end
    end
    return notice
  end
  
  def toggle_admin(email)
    if email == self.email
      return "Cannot unadmin yourself"
    else
      user = find_by_email(email)
      if user
        new_admin_status = !user.admin
        if User.update(user, :admin => new_admin_status)
          return email + " admin status: " + new_admin_status.to_s
        else
          return "Toggle failed"
        end
      else #Could not find the user
        return email + " does not exist"
      end
    end
  end
end
