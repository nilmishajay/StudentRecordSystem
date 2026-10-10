
class CoursesController < ApplicationController
  before_action :require_login

  def index
    @courses = Course.order(:code)
  end

  def show
    @course = Course.find(params[:id])
  end
end

