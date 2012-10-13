namespace :devise do

  desc 'setup admin user'
  
  task :setup_admin => ['environment'] do
    admin = Admin.create! do |u|
      u.email = 'admin@heroku.com'
      u.password = '2dkay9pr3t'
      u.password_confirmation = '2dkay9pr3t'
    end
    admin.save!
    puts 'Admin created!'
    puts 'Email : ' << admin.email
    puts 'Password: ' << admin.password
  end
  
end