class Channel < ApplicationRecord

  has_many :channel_services

  validates :name, presence: true, uniqueness: true
  validates :channel, presence: true, uniqueness: true

  class << self
    def permit_attrs
      %i(name channel)
    end
  end
end
