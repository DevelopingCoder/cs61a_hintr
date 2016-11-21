FactoryGirl.define do
    factory :user do
        name "Regular User"
        email "testuser@gmail.com"
        password "password"
        admin false
    end

    factory :admin, class: User do
        name "Admin User"
        email "testadmin@gmail.com"
        password "password"
        admin true
    end
    
    factory :concept do 
        name "Example_concept"
        description "This is my example concept"
    end
end