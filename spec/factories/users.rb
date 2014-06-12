FactoryGirl.define do
  sequence(:member_mail) {|n| "member_#{n}@helpdesk.test"}

  factory :user do
    name Forgery(:name).first_name
    email :member_mail
    password "password"
    password_confirmation "password"
  end
end
