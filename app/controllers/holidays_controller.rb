class HolidaysController < ApplicationController
  before_action :authenticate_user!
  def index
    @holidays=Holiday.all
  end
end
