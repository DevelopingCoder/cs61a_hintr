require 'securerandom'

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  validates :name, presence: :true
  has_many :votes
  has_many :messages, :through => :votes

  @@successful_del = "User successfully deleted"
  @@successful_add = "Email invite has been sent"
  @@invalid_action = "Something went wrong. You may have performed an invalid action"

  def self.verify_first_line(first_line)
    #Check format: concept, description, message
    first_line = first_line.split(",")
    if first_line.length < 2
      return false
    end
    name_matches = first_line[0].downcase.include?("name")
    email_matches = first_line[1].downcase.include?("email")
    return name_matches && email_matches 
  end
    
  def self.import(current_user, file)
    
    first_line = file.readline
    if not self.verify_first_line(first_line)
        return "Users file not correctly formatted. First 2 columns must be Name, Email"
    end
    users_created = []
    file.each do |line|
      name, email = line.split(",")
      if name and email
        name = name.strip
        email = email.strip
        if current_user.add_email(email, name) == "Email invite has been sent"
          users_created += [email]
        end
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
  
  def add_email(email, name)
    # takes in an email and optional name param
    # returns success of user creation
    
    # Check if email is already being used
    password = SecureRandom.urlsafe_base64(6)
    if User.find_by_email(email)
      return "Email already exists in database"
    end
    user = User.create({:name=>name, :email => email, :password => password})
    if user.id
      #send the email
      if User.send_email(email, password)
        return @@successful_add
      end
    end
    return @@invalid_action
  end
  
  def delete_email(email)
    if email == self.email
      return "User cannot delete self"
    end
    user = User.find_by_email(email)
    if user
      if User.destroy(user.id) 
        return @@successful_del
      end
    end
    return @@invalid_action
  end
  
  def delete_emails(emails)
    notice = "Successfully deleted:"
    emails.each do |email|
      if delete_email(email) == @@successful_del
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
        end
      end
      return @@invalid_action
    end
  end
  
end
