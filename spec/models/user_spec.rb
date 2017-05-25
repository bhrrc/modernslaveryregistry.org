require 'rails_helper'

RSpec.describe User, type: :model do
  it 'becomes admin on confirmation when email domain is business-humanrights.org' do
    user = User.create!(first_name: 'Someone',
                        last_name: 'Smith',
                        email: 'someone@business-humanrights.org',
                        password: 's3cr3t')
    user.confirm
    expect(user.admin?).to be(true)
  end

  it 'does not become admin on confirmation when email domain is not business-humanrights.org' do
    user = User.create!(first_name: 'Someone',
                        last_name: 'Smith',
                        email: 'someone@gov.uk',
                        password: 's3cr3t')
    user.confirm
    expect(user.admin?).to be(false)
  end
end
