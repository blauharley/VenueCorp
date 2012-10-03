module ApplicationHelper
  def get_event_ids(events)
    ids = ''
    events.each do |event|
      ids += event.id.to_s << ','
    end
    ids = ids[0...ids.length-1]
    ids
  end
  
  def get_formated_repeat_dates repeat_attr, start_date
    repeat_attr = repeat_attr.split(' ')
    repeat_kinds = { 'never' => 0, 'weekly' => 7, 'all_14_days' => 14, 'monthly' => 30 }
    
    formated_dates = [start_date]
    if repeat_attr[0] != 'never' && repeat_attr[1]
      for i in 0...repeat_attr[1].to_i
        formated_dates << (start_date + repeat_kinds[repeat_attr[0]].days)
        start_date = (start_date + repeat_kinds[repeat_attr[0]].days)
      end
    end
    
    formated_dates
  end
  
end
