Rails.application.routes.draw do

  resources :courses, only: [:index] do
    resources :recipes, except: [:new, :edit], controller: 'course_recipes'
  end
  resources :recipes

end

#except: [:new, :edit] takes out the uneeded resources, but it doesn't affect how things run if it wasn't included.