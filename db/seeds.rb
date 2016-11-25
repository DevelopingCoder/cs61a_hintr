# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

users = [{:name => 'testadmin', :email => 'testadmin@gmail.com', :password => 'password', :admin => true}]

users.each do |user|
  User.create!(user)
end

50.times do |i|
    User.create!({:name => 'user' + i.to_s, :email => 'testuser' + i.to_s + '@gmail.com', :password => 'password', :admin => false})
end

20.times do |i| 
    concept = Concept.create!({:name => 'concept-' + i.to_s, :msg_status => 'no messages', :description => 'description for concept ' + i.to_s})
    10.times do |j|
        concept.messages.create!({:author => 'user' + j.to_s, :content => 'content ' + j.to_s, :finalized => false})
        concept.tags.create!({:name => 'tag- ' + j.to_s, :description => 'tag-description- ' + j.to_s, :example => 'insert example'})
    end
end
