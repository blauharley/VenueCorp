desc "This task is called by the Heroku scheduler add-on"

task :delete_pdfs => :environment do
  events = Event.find(:all))
  
  events.each do |event|
    if File.file? (Dir.pwd + '/' + event.title + ".pdf")
      File.delete( (Dir.pwd + '/' + event.title + ".pdf") )
    end
  end
end