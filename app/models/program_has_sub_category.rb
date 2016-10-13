class ProgramHasSubCategory < ApplicationRecord
  belongs_to :program
  belongs_to :sub_category
end
