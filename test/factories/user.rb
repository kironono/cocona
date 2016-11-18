FactoryGirl.define do
  factory :user, class: User do
    sequence :name do |n|
      "cocona_#{n}"
    end
    sequence :email do |n|
      "cocona_#{n}@example.com"
    end
    password 'passw0rd!'
    locale 'ja'
  end
end
