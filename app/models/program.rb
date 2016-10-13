class Program < ApplicationRecord
  belongs_to :channel
  belongs_to :channel_service
  has_many :reservations
  has_many :program_has_sub_categories
  has_many :sub_categories, through: :program_has_sub_categories

  def main_categories
    MainCategory.where(id: sub_categories.pluck(:main_category_id)).all
  end
end
