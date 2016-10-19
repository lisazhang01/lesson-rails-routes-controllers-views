class Recipe < ActiveRecord::Base
  belongs_to :course

  has_many :recipe_ingredient_lists
  has_many :ingredients, through: :recipe_ingredient_lists

  validates :name, :instructions, :servings, :course_id, presence: true
  validates :name, uniqueness: true
  validates :name, length: { minimum: 2 }
  validates :servings, :course_id, numericality: { only_integer: true }
end
