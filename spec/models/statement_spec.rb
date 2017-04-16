require "rails_helper"

RSpec.describe Statement, :type => :model do
  before do
    @sw = Sector.create! name: 'Software'
    @gb = Country.create! code: 'GB', name: 'United Kingdom'
    @company = Company.create! name: 'Cucumber Ltd', country_id: @gb.id, sector_id: @sw.id
  end

  it "converts url to https if it exists" do
    VCR.use_cassette("cucumber.io") do
      statement = @company.statements.create!({
        url: 'http://cucumber.io/',
        approved_by: 'Big Boss',
        approved_by_board: 'Yes',
        signed_by_director: false,
        link_on_front_page: true,
        date_seen: Date.parse('21 May 2016')
      })

      expect(statement.url).to eq('https://cucumber.io/')
    end
  end

  it "does not validate admin-only visible fields for non-admins" do
    VCR.use_cassette("cucumber.io") do
      statement = @company.statements.create({
        url: 'http://cucumber.io/',
        verified_by: nil
      })

      expect(statement.errors.messages).to eq({})
    end
  end

  it "validates admin-only visible fields for admins" do
    VCR.use_cassette("cucumber.io") do
      user = User.create!({
        first_name: 'Someone',
        last_name: 'Smith',
        email: 'someone@somewhere.com',
        password: 'whatevs'
      })

      statement = @company.statements.create({
        url: 'http://cucumber.io/',
        verified_by: user
      })

      expect(statement.errors.messages).to eq({
        approved_by_board: ["is not included in the list"],
        link_on_front_page: ["is not included in the list"],
        signed_by_director: ["is not included in the list"]
      })
    end
  end
end
