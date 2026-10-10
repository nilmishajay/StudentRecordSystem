class StudentsController < ApplicationController
  before_action :set_student, only: %i[show edit update destroy]

  def index
    @students = Student.includes(:course).order(:student_number)
  end

  def show
    @enrolments = @student.enrolments.includes(:result, unit: :course).order(academic_year: :desc, semester: :asc)
  end

  def new
    @student = Student.new
  end

  def create
    @student = Student.new(student_params)

    if @student.save
      redirect_to @student, notice: "Student was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @student.update(student_params)
      redirect_to @student, notice: "Student was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @student.enrolments.exists?
      redirect_to students_path,
                  alert: "Student cannot be deleted because enrolments or academic results are associated with this record."
    elsif @student.destroy
      redirect_to students_path, notice: "Student was successfully deleted."
    else
      redirect_to students_path,
                  alert: @student.errors.full_messages.to_sentence.presence ||
                         "Student could not be deleted because related records exist."
    end
  rescue ActiveRecord::InvalidForeignKey
    redirect_to students_path,
                alert: "Student cannot be deleted because enrolments or academic results are associated with this record."
  end

  private

  def set_student
    @student = Student.find(params[:id])
  end

  def student_params
    params.require(:student).permit(
      :student_number,
      :first_name,
      :last_name,
      :email,
      :course_id
    )
  end
end
