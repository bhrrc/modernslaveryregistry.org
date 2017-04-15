Given(/^(Joe|Patricia) is logged in$/) do |actor|
  user = User.create!({
    email: "#{actor.name}@host.com",
    password: 's3cr3t',
    admin: true,
    confirmed_at: DateTime.current
  })
  login_as(user)
end
