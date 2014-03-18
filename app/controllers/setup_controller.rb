
require 'Choose'

class SetupController < ApplicationController

  def show
    @languages_names = dojo.languages.map{|language| language.name}
    @exercises_names = dojo.exercises.map{|exercise| exercise.name}
    @instructions = { }
    @exercises_names.each do |name|
      @instructions[name] = dojo.exercises[name].instructions
    end
    @selected_language_index = Choose::language(@languages_names, params[:id], id, dojo)
    @selected_exercise_index = Choose::exercise(@exercises_names, params[:id], id, dojo)
    @id = id
    @title = 'Setup'
  end

  def save
    language = dojo.languages[params['language']]
    exercise = dojo.exercises[params['exercise']]
    kata = dojo.make_kata(language, exercise)

    logger.info("Created dojo " + kata.id +
                ", " + language.name +
                ", " + exercise.name +
                ", " + make_time(Time.now).to_s)

    render :json => {
      :id => kata.id
    }
  end

end
