# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :list do
    name "Shopping List"
    permissions "private"
    user_id :user
  end
end
