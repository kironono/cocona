FactoryGirl.define do
  factory :user, class: User do
    name 'cocona'
    email 'cocona@example.com'
    password 'passw0rd!'
    locale 'ja'
  end
end
