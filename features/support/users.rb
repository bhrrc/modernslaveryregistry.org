module Users
  def find_or_create_user(name:, admin:)
    User.where(
      first_name: name,
      email: "#{name}@test.com",
      admin: admin
    ).first_or_create!(
      password: 's3cr3t',
      confirmed_at: Time.zone.now
    )
  end
end

World(Users)
