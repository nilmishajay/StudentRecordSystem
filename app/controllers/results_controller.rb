
class ResultsController < ApplicationController
  before_action :require_login

  def index
    @results = Result.includes(enrolment: [:student, :unit]).order(:id)
  end

  def show
    @result = Result.includes(enrolment: [:student, :unit]).find(params[:id])
  end
end
