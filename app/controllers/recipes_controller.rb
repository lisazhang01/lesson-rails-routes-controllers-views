class RecipesController < ApplicationController

#Runs these following methods first as they are needed in many places
  before_action :set_errors
  before_action :set_parent_path
  before_action :set_courses_category, only: [:new, :edit]
  before_action :set_recipe, only: [:show, :edit, :update, :destroy]
  before_action :get_recipes, only: [:index]

#Index is inherited by CourseRecipesController
  def index
    render 'recipes/index'
  end

#show recipe
  def show
    render 'recipes/show'
  end

#To make a new recipe
  def new
    @recipe = flash[:recipe].nil? ? Recipe.new : Recipe.new(flash[:recipe])
  end

#For a newly created recipe
  def create
    @recipe = Recipe.new(recipe_params) #see method recipe_params

    if @recipe.save
      redirect_to @recipe #takes user back to the show recipe page after they have created a new recipe
    else
      flash[:recipe] = @recipe
      flash[:errors] = @recipe.errors.messages
      redirect_to new_recipe_path #new_recipe prefix from resources
    end
  end

#To edit recipe
  def edit
    @recipe = flash[:recipe].nil? ? @recipe : Recipe.new(flash[:recipe])
  end

#Update the page
  def update
    @recipe.assign_attributes(recipe_params)

    if @recipe.save
      redirect_to @recipe
    else
      flash[:recipe] = @recipe
      flash[:errors] = @recipe.errors.messages
      redirect_to new_recipe_path
    end
  end

#Delete recipe
  def destroy
    if !@recipe.nil? #build in this just to be sure
      @recipe.destroy
    end
      redirect_to "#{@parent_path}#{recipes_path}" #recipes_path is a get resource prefix
  end


private

#Save all recipes to variables so it can be used later
  def set_recipes
    @recipes = Recipe.includes(:ingredients).all #includes will cache the ingredients info and keep it there for later use, instead of querying again for this info later when it is needed
    @message = "No Recipes Found" if @recipes.empty?
  end

#Finds recipe by id
  def set_recipe
    @recipe  = Recipe.find_by(id: params[:id])
    @message = "Cannot find recipe with id #{params[:id]}"
  end

#Errors for
  def set_errors
    @errors = flash[:errors]
  end

#Grabs list of course names
  def set_courses_category
    @courses_categories = Course.order(:name).pluck(:name, :id)
  end

#Set parent path to home or current page, used in recipe index.html
  def set_parent_path
    @parent_resource = "/"
    @parent_path     = ""
  end

#Strong params: checks input to see if keys match the ones that we want and not different
  def recipe_params
    params.require(:recipe).permit(:name, :instructions, :servings, :course_id)
  end

  def recipe_ingredients_params
    params.require(:recipe).permit(:ingredients)
  end

end
