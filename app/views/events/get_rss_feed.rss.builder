xml.instruct! :xml, :version => "1.0", :standalone => "yes"
xml.rss :version => "2.0", "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance", "xmlns:xsd" => "http://www.w3.org/2001/XMLSchema" do
  xml.channel do
    xml.title "Veranstaltungen in Oesterreich"
    xml.description "all events"
    xml.link root_path
    xml.language 'de'
    
    for event in @events
      xml.item do
        xml.id event.id
        xml.title event.title
        xml.pubDate event.created_at
        xml.description event.description
        xml.category (event.main_category << '/' << event.sub_category)
        xml.link ('http://event-corp.herokuapp.com' + event_path(event.id))
        xml.price event.costs
        if event.image.exists?
          xml.image do |x|
            x.url event.image.path
            x.title event.title
            x.link event.image.path
          end 
        end
      end
    end
  end
end