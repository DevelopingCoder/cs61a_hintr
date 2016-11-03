require 'securerandom'

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :votes
  has_many :messages, :through => :votes

  def self.import(current_user, file)
    users_created = []
    read_first_line = false
    File.open(file.tempfile).each do |line|
      if not read_first_line
        read_first_line = true
        next
      end
      
      name, email = line.split(",")
      name = name.strip
      email = email.strip
      if current_user.add_email(email, name) == "Email invite has been sent"
        users_created += [email]
      end
    end
    return "Users Created: " + users_created.join(", ")
  end
  
  def self.send_email(email, password)
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
    
    mail = Mail.new do
      from     'do-not-reply@hintr.app.com'
      to       email
      subject  'Welcome to cs61a Hintr!'
      
      text_part do
        body  "Welcome to hintr!\n" + 
              "Your login is: " + email + "\n" + 
              "Your password is: " + password + "\n" + 
              "Make sure to change your password and set your name when you first log in.\n"+
              "Login at: https://cs61a-hintr.herokuapp.com"
      end
    end
    mail.deliver
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
      if User.send_email(email, password)
        return "Email invite has been sent"
      else
        return "Email invite not sucessfully sent"
      end
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
  
  def toggle_admin(id, status)
    if id == self.id
      return "Cannot unadmin yourself"
    else
      other_user = User.find_by_id(id)
      if other_user
        if other_user.update_attributes(:admin => status)
          if status == true
            return other_user.name + " is now an admin"
          else
            return other_user.name+ " is no longer an admin. Lol"
          end
        else
          return "Toggle failed"
        end
      else #Could not find the user
        return "Invalid id"
      end
    end
  end
  
end
