class SubCategory < ApplicationRecord
  belongs_to :main_category
  has_many :program_has_sub_categories
  has_many :programs, through: :program_has_sub_categories
end
