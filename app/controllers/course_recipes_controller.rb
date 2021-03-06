class CourseRecipesController < RecipesController #Change inheritance from ApplicationController to RecipeController
  before_action :set_course

# public methods are inherited from recipecontroller

private
  def set_recipes
    if not @course.nil? #if course does exist
      @recipes = @course.recipes
      @message = "No recipes found" if @recipes.empty? #if recipes is empty give msg
    end
  end

  def get_recipe
    if not @course.nil?
      @recipe = @course.recipes.find_by(id: params[:id])
      @message = "Cannot find recipe with ID #{params[:id]}" if @recipe.nil?
    end
  end

  def set_course
    @course = Course.find_by(name: params[:course_id]) #if can't find it, find_by will give a nil, whereas find will return an error
    if @course.nil?
      @recipes = []
      @recipe = nil
      @message = "Course Cannot be Found"
    end
  end

  def set_parent_path
    @parent_resource = "/courses"
    @parent_path     = "/courses/#{params[:course_id]}"
  end
end

