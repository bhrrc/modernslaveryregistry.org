namespace :user do
  desc 'Make a user an admin user'
  task :make_admin, [:email] => :environment do |_task, args|
    if user = User.find_by_email(args[:email])
      user.admin = true
      user.save
    else
      puts "User email '#{args[:email]}' not found. Nothing was done."
    end
  end
end
