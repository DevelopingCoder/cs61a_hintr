class QuestionSetsController < ApplicationController

  def index
    @question_sets = QuestionSet.all
    @hint_threshold = Rails.application.config.hintthreshold
  end

  def show
    @question_set = QuestionSet.find(params[:id])
  end

end
