Given(/^(Joe|Patricia) is logged in$/) do |actor|
  user = User.create!({
    email: "#{actor.name}@host.com",
    password: 's3cr3t',
    admin: true
  })
  login_as(user)
end
