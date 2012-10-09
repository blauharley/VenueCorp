namespace :devise do

  desc 'setup admin user'
  
  task :setup_admin => ['environment'] do
    user = User.create! do |u|
      u.email = 'user@test.com'
      u.password = 'user123'
      u.password_confirmation = 'user123'
    end
    user.save!
    puts 'New user created!'
    puts 'Email : ' << user.email
    puts 'Password: ' << user.password
  end
  
end