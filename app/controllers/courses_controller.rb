class CoursesController < ApplicationController
  before_action :set_course, only: %i[show edit update destroy]

  def index
    @courses = Course.order(:code)
  end

  def show
    @units = @course.units.order(:code)
    @students = @course.students.order(:student_number)
  end

  def new
    @course = Course.new
  end

  def create
    @course = Course.new(course_params)

    if @course.save
      redirect_to @course, notice: "Course was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @course.update(course_params)
      redirect_to @course, notice: "Course was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @course.students.exists? || @course.units.exists?
      redirect_to courses_path,
                  alert: "Course cannot be deleted while students or units are assigned to it."
    elsif @course.destroy
      redirect_to courses_path, notice: "Course was successfully deleted."
    else
      redirect_to courses_path,
                  alert: @course.errors.full_messages.to_sentence.presence || "Course could not be deleted because related records exist."
    end
  rescue ActiveRecord::InvalidForeignKey
    redirect_to courses_path,
                alert: "Course cannot be deleted while students or units are assigned to it."
  end

  private

  def set_course
    @course = Course.find(params[:id])
  end

  def course_params
    params.require(:course).permit(:code, :name, :description)
  end
end





