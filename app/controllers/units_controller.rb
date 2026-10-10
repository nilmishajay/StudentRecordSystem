
class UnitsController < ApplicationController
  before_action :require_login

  def index
    @units = Unit.includes(:course).order(:code)
  end

  def show
    @unit = Unit.find(params[:id])
  end
end
