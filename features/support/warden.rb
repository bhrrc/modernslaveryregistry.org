# Make sure #login_as etc are available in step defs
Before do
  Warden.test_mode!
end

After do
  Warden.test_reset!
end

World(Warden::Test::Helpers)
