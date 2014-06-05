# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:username, 100) { |n| "person#{n}" }
 #   username "myusername"
    password "mypassword"
  end
end
