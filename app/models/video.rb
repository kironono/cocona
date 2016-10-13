class Video < ApplicationRecord
  has_many :video_has_sub_categories
  has_many :sub_categories, through: :video_has_sub_categories

  def main_categories
    MainCategory.where(id: sub_categories.pluck(:main_category_id)).all
  end
end
