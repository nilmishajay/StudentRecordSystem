class EnrolmentsController < ApplicationController
  before_action :set_enrolment, only: %i[show destroy]

  def index
    @enrolments = Enrolment.includes(:student, :result, unit: :course).order(academic_year: :desc, semester: :asc)
  end

  def show
  end

  def new
    @enrolment = Enrolment.new(student_id: params[:student_id], unit_id: params[:unit_id])
    load_form_options
  end

  def create
    @enrolment = Enrolment.new(enrolment_params)

    if @enrolment.save
      redirect_to @enrolment.student, notice: "Student was successfully enrolled in the unit."
    else
      load_form_options
      render :new, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotUnique
    @enrolment.errors.add(:base, "This student is already enrolled in that unit for the selected semester and academic year.")
    load_form_options
    render :new, status: :unprocessable_entity
  end

  def destroy
    student = @enrolment.student

    if @enrolment.result.present?
      redirect_to student,
                  alert: "This enrolment cannot be deleted because an academic result is recorded for it."
    elsif @enrolment.destroy
      redirect_to student, notice: "Enrolment was successfully removed."
    else
      redirect_to student,
                  alert: @enrolment.errors.full_messages.to_sentence.presence || "Enrolment could not be removed because academic records are associated with it."
    end
  rescue ActiveRecord::InvalidForeignKey
    redirect_to student || enrolments_path,
                alert: "This enrolment cannot be deleted because dependent academic records are associated with it."
  end

  private

  def set_enrolment
    @enrolment = Enrolment.includes(:student, :result, unit: :course).find(params[:id])
  end

  def enrolment_params
    params.require(:enrolment).permit(:student_id, :unit_id, :semester, :academic_year)
  end

  def load_form_options
    @students = Student.includes(:course).order(:student_number)
    @units = Unit.includes(:course).order(:code)
  end
end
