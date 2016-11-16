class QuestionSetsController < ApplicationController
  before_action :set_question_set, only: [:show, :edit, :update, :destroy]

  def index
    @question_sets = QuestionSet.all
  end

  def show
  end

end
