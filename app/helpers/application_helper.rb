module ApplicationHelper
  def get_event_ids(events)
    ids = ''
    events.each do |event|
      ids += event.id.to_s << ','
    end
    ids = ids[0...ids.length-1]
    ids
  end
end
