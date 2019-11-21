require 'date'
require 'holiday_jp'

class Schedule
  attr_reader :started_on, :due_on, :today

  WORK_START_TIME = 9
  WORK_END_TIME = 18

  def initialize(due_on)
    @started_on = Date.parse(Config.instance.started_on)
    @due_on = due_on
    @today = Date.today

    @total_dates = bussiness_dates(@started_on, @due_on)
    @remaining_dates = bussiness_dates(@today, @due_on) 
    @worked_dates = bussiness_dates(@started_on, @today - 1)
  end

  # 開始時から終了時までの日数
  #
  def total_days
    @total_dates.count
  end

  # 残日数
  #
  def remaining_days
    @remaining_dates.count - time_elapsed_rate_today
  end

  # 作業済日数
  #
  def worked_days
    @worked_dates.count + time_elapsed_rate_today
  end

  private

  def bussiness_dates(from, to)
    (from..to).select { |date| !HolidayJp.holiday?(date) && !date.saturday? && !date.sunday? }
  end

  # 本日の時刻経過度合
  #
  def time_elapsed_rate_today
    if Time.now.hour <= WORK_START_TIME
      1
    elsif Time.now.hour >= WORK_END_TIME
      0
    else
      (Time.now.hour - WORK_START_TIME).fdiv(WORK_END_TIME - WORK_START_TIME).round(1)
    end
  end
end
