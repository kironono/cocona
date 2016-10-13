module ReserveRulesHelper

  def channel_service_name_get_by_id(id)
    channel_service = ChannelService.where(id: id).first
    if channel_service.present?
      return channel_service.name_with_service_id
    end
  end

  def main_category_name_get_by_id(id)
    main_category = MainCategory.where(id: id).first
    if main_category.present?
      return main_category.name
    end
  end
end
