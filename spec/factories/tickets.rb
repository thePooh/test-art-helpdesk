FactoryGirl.define do
  factory :ticket do
    user_name Forgery(:name).full_name
    user_email Forgery(:internet).email_address
  end
end
