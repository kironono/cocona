class ChannelService < ApplicationRecord

  belongs_to :channel

  def name_with_service_id
    "#{name} (#{service_id})"
  end
end
