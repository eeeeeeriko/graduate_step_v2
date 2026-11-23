
class WineRecordsController < ApplicationController
  before_action :authenticate_user!

  def index
    @wine_records = current_user.wine_records.order(created_at: :desc)
  end

  def new
    @wine_record = WineRecord.new
  end

  def create
    @wine_record = current_user.wine_records.build(wine_record_params)

    if @wine_record.save
        redirect_to wine_records_path, notice: t("wine_records.create.success")
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def wine_record_params
    params.require(:wine_record).permit(
      :name, :acidity, :tannin, :sweetness, :satisfaction
    )
  end
end
