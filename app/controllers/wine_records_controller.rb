class WineRecordsController < ApplicationController
  before_action :authenticate_user!

  def new
    @wine_record = WineRecord.new
  end
end