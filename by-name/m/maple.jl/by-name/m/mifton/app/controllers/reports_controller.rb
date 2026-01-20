class ReportsController < ApplicationController

  def create
    @report = current_user.reports.build(report_params)

    if @report.save

      redirect_to "/#{params[:reported_object_id]}"
    else
      render :show
    end
  end

  def show
    @type = params[:report][:type]
    @id = params[:report][:post_id]
  end

  private
    def report_params
      params.require(:report).permit(
        :report_reason,
        :reported_object_id,
        :reported_object_type
      )
    end
end
