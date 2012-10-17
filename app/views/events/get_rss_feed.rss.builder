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
        xml.description event.description
        
      end
    end
  end
end