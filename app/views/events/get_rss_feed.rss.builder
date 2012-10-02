xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Veranstaltungen Steiermark RSS-Feeds"
    xml.description "all events"
    xml.link root_path

    for event in @events
      xml.item do
        xml.id event.id
        xml.title event.title
        xml.long_description event.description
        xml.costs event.costs
        xml.address event.address
        xml.province event.province
        xml.region event.region
        xml.city event.city
        xml.main_category event.main_category
        xml.sub_category event.sub_category
        xml.highlight event.highlight
        xml.venue event.venue
        xml.start_date event.start_date
        xml.end_date event.end_date
        xml.start_date_time event.start_date_time
        xml.end_date_time event.end_date_time
        xml.image event.image.path
        xml.venue_url event.venue_url
        xml.email event.email
        xml.tel_nr event.tel_nr
      end
    end
  end
end