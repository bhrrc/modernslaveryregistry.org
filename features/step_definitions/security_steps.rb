Given(/^(Joe|Patricia) is logged in$/) do |actor|
  user = User.create!({
    first_name: actor.name,
    email: "#{actor.name}@business-humanrights.org",
    password: 's3cr3t'
  })
  user.confirm
  login_as(user)
end
