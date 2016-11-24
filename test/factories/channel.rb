FactoryGirl.define do
  factory :channel, class: Channel do
    sequence :name do |n|
      "channel_#{n}"
    end
    sequence :channel do |n|
      n
    end
  end
end
