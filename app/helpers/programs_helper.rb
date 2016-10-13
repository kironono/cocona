module ProgramsHelper

  def channel_service_collection
    ChannelService.order('channel_id', 'service_id').all.map do |r|
      [r.name_with_service_id, r.id.to_s]
    end
  end

  def main_categories_collection
    MainCategory.all.map do |r|
      [r.name, r.id.to_s]
    end
  end
end
