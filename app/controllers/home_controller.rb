class HomeController < ApplicationController
  def index
    @student_count = Student.count
    @course_count = Course.count
    @unit_count = Unit.count
    @enrolment_count = Enrolment.count
    @result_count = Result.count
  end
end
