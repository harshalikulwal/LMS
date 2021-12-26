class LeaveInfo < ApplicationRecord
  belongs_to :user
  validates   :start_date, :end_date, :reason_for_leave, :user_id, :presence => true

  def leave_array(start_date, end_date)
    actual_start = actual_start_date(start_date)
    actual_end = actual_end_date(end_date)
    l_date_array = []
    no_of_days = (actual_end -actual_start).to_i
    for no_of_day in 0..no_of_days
      l_date_array << actual_start
      actual_start = actual_start + 1
    end
    l_date_array
  end

  def string_to_date(p_date)
    str_array = p_date.split("/")
    convert_to_date(str_array[2].to_i, str_array[1].to_i, str_array[0].to_i)
  end

  def convert_to_date(year, month, day)
    Date.new(year, month, day)
  end

  def actual_start_date(date)
    original_date = date
    date = date -1
    count = 0
    while Holiday.where(:day =>date.day, :month => date.month, :year => date.year).present?
      date = date -1
      count = count + 1
    end
    original_date - count
  end

  def actual_end_date(date)
    original_date = date
    date = date + 1
    count = 0
    while Holiday.where(:day =>date.day, :month => date.month, :year => date.year).present?
      date = date + 1
      count = count + 1
    end
    original_date + count
  end
end
