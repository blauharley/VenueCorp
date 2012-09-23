module EventsHelper
  def convert_date_to_time date
    if date
      date.to_time
    else
      date
    end
  end
end
