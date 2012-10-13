desc 'setup admin user'
  
task :setup_admin => :environment do
  admin = Admin.create! do |u|
    u.email = ''
    u.password = ''
    u.password_confirmation = ''
  end
  admin.save!
  puts 'Admin created!'
  puts 'Email : ' << admin.email
  puts 'Password: ' << admin.password
end