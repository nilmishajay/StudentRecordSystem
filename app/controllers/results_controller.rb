
class ResultsController < ApplicationController
  before_action :set_result, only: %i[show edit update]

  def index
    @results = Result.includes(enrolment: %i[student unit]).order(:id)
  end

  def show
  end

  def new
    @result = Result.new(enrolment_id: params[:enrolment_id])
    load_enrolment_options
  end

  def create
    @result = Result.new(result_params)

    if @result.save
      redirect_to @result, notice: "Academic result was successfully recorded."
    else
      load_enrolment_options
      render :new, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotUnique
    @result.errors.add(:enrolment_id, "already has a recorded result")
    load_enrolment_options
    render :new, status: :unprocessable_entity
  end

  def edit
    load_enrolment_options
  end

  def update
    if @result.update(result_params)
      redirect_to @result, notice: "Academic result was successfully updated."
    else
      load_enrolment_options
      render :edit, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotUnique
    @result.errors.add(:enrolment_id, "already has a recorded result")
    load_enrolment_options
    render :edit, status: :unprocessable_entity
  end

  private

  def set_result
    @result = Result.includes(enrolment: %i[student unit]).find(params[:id])
  end

  def result_params
    params.require(:result).permit(:enrolment_id, :mark, :grade)
  end

  def load_enrolment_options
    @enrolments = Enrolment.includes(:student, unit: :course)
                           .left_outer_joins(:result)
                           .where("results.id IS NULL OR enrolments.id = ?", @result.enrolment_id || 0)
                           .order(academic_year: :desc, semester: :asc)
  end
end
