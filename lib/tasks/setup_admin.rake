namespace :devise do

  desc 'setup admin user'
  
  task :setup_admin => ['environment'] do
    admin = Admin.create! do |u|
      u.email = 'admin@admin.com'
      u.password = 'admin123'
      u.password_confirmation = 'admin123'
    end
    admin.save!
    puts 'Admin created!'
    puts 'Email : ' << admin.email
    puts 'Password: ' << admin.password
  end
  
end