class RecipesController < ApplicationController
  before_action :set_parent_path


  def index #this is inherited by CourseRecipesController
    get_recipes
    render 'recipes/index'
  end

#show recipe
  def show
    get_recipe #see protected method below
    render 'recipes/show'
  end

#To make a new recipe
  def new
    @recipe = flash[:recipe].nil? ? Recipe.new(flash[:recipe]) : Recipe.new
    @errors = flash[:errors]
    @courses = Course.order(:name).pluck(:name, :id)
  end

#For a newly created recipe
  def create
    @recipe = Recipe.new(recipe_params) #see method recipe_params
    if @recipe.save
      redirect_to @recipe #takes user back to the show recipe page after they have created a new recipe
    else
      flash[:recipe] = @recipe #
      flash[:errors] = @recipe.errors.messages
      redirect_to new_recipe_path #new_recipe prefix from resources
    end
  end

#To edit recipe


private
  def set_parent_path
    @parent_resource = "/"
    @parent_path = ""
  end

  def recipe_params #Strong params: checks input to see if keys match the ones that we want and not different
    params.require(:recipe).permit(:name, :instructions, :servings, :course_id)
  end

protected #this is not inherited because it is private
  def get_recipes
    @recipes = Recipe.all
    @message = "No Recipes Found" if @recipes.empty?
  end

  def get_recipe
    @recipe = Recipe.find_by(id: params[:id])
    @message = "Cannot find recipe with id #{params[:id]}"
  end
end
