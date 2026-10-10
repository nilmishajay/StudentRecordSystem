
class UnitsController < ApplicationController
  before_action :set_unit, only: %i[show edit update destroy]

  def index
    @units = Unit.includes(:course).order(:code)
  end

  def show
    @students = @unit.students.order(:student_number)
  end

  def new
    @unit = Unit.new(course_id: params[:course_id])
  end

  def create
    @unit = Unit.new(unit_params)

    if @unit.save
      redirect_to @unit, notice: "Unit was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @unit.update(unit_params)
      redirect_to @unit, notice: "Unit was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @unit.enrolments.exists?
      redirect_to units_path,
                  alert: "Unit cannot be deleted because student enrolments or academic results are associated with it."
    elsif @unit.destroy
      redirect_to units_path, notice: "Unit was successfully deleted."
    else
      redirect_to units_path,
                  alert: @unit.errors.full_messages.to_sentence.presence || "Unit could not be deleted because related records exist."
    end
  rescue ActiveRecord::InvalidForeignKey
    redirect_to units_path,
                alert: "Unit cannot be deleted because student enrolments or academic results are associated with it."
  end

  private

  def set_unit
    @unit = Unit.includes(:course).find(params[:id])
  end

  def unit_params
    params.require(:unit).permit(:code, :name, :credit, :course_id)
  end
end
