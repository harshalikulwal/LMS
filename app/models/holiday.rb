class Holiday < ApplicationRecord
  validates   :day, :wday, :month, :year, :reason, :presence => true

  def holiday_between_leaves(start_date, end_date)
    start_date = actual_start_date(start_date)
    end_date = actual_end_date(end_date)
    if start_date.year != end_date.year
      start_month = Holiday.where(:month => start_date.month, :day => [start_date.day..31], :year => start_date.year )
      end_month = Holiday.where(:month => end_date.month, :day => [1..end_date.day], :year => end_date.year)
      holidays = start_month + end_month
    elsif start_date.month != end_date.month
      start_month = Holiday.where(:month => start_date.month, :day => [start_date.day..31], :year => start_date.year)
      end_month = Holiday.where(:month => end_date.month, :day => [1..end_date.day], :year => start_date.year)
      holidays = start_month + end_month
    else
      holidays = Holiday.where(:month => start_date.month, :day => [start_date.day..end_date.day], :year => start_date.year)
    end
    holidays_in_date_formate = []
    holidays.each do |holiday|
      holidays_in_date_formate << Date.new(holiday.year, holiday.month, holiday.day)
    end
    holidays_in_date_formate
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
