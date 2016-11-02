class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  has_many :votes
  has_many :messages, :through => :votes
  validates :name, presence: true
  
  def self.import(file)
    users_created = []
    File.open(file.tempfile).each do |line|
      name, email = line.split(",")
      name = name.strip
      email = email.strip
      byebug
      if User.create({:name => name, :email => email}).id
        users_created += [email]
      end
    end
    return "Users Created: " + users_created.join(", ")
  end
  
  def send_email()
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
end
