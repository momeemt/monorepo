class ManageReportsController < ApplicationController
  include Common
  before_action :permit_admin

  def index
    @reports = Report.all
  end

end
