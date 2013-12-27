FactoryGirl.define do
  factory :user do
    name "Dave"
    email "dave@davetopia.org"
    password "passw0rd"
    password_confirmation "passw0rd"
  end
end
