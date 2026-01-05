require 'sidekiq-scheduler'

class WeeklyDayGenerator
  include Sidekiq::Worker

  def perform
    # Get the most recent day in the table
    last_day = Day.order(:day).last
    return unless last_day

    base_date = last_day.day

    # Calculate the next Saturday and Sunday after the last day
    next_saturday = base_date.next_occurring(:saturday)
    next_sunday   = base_date.next_occurring(:sunday)

    # Create new Day records for Saturday and Sunday, if they don't already exist
    [next_saturday, next_sunday].each do |date|
      Day.find_or_create_by(day: date) do |day|
        day.active_flag = true
      end
    end
  end
end
