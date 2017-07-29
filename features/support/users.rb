module Users
  def find_or_create_user(actor)
    User.where(
      first_name: actor.name,
      email: actor.email,
      admin: actor.admin?
    ).first_or_create!(
      password: 's3cr3t',
      confirmed_at: Time.zone.now
    )
  end
end

World(Users)
