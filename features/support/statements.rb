module Statements
  def submit_statement(props)
    verifier = find_or_create_verifier(props)
    company = find_or_create_company(props)
    create_statement(company, verifier, props)
  end

  private

  def find_or_create_company(props)
    sector = Sector.find_by!(name: props['Sector'] || 'Software')
    country = Country.find_by!(name: props['Country'] || 'United Kingdom')
    company = Company.find_or_create_by!(name: props['Company name'], sector: sector, country: country)
    company
  end

  def find_or_create_verifier(props)
    props['Verified by'].present? && User.where(
      first_name: props['Verified by'],
      email: "#{props['Verified by']}@host.com"
    ).first_or_create(password: 'whatevs')
  end

  def create_statement(company, verifier, props)
    company.statements.create!(
      url: props.fetch('Statement URL'),
      signed_by_director: props['Signed by director'] == 'Yes',
      approved_by_board: props['Approved by board'] || 'Not explicit',
      link_on_front_page: props['Link on front page'] == 'Yes',
      contributor_email: props['Contributor email'],
      verified_by: verifier,
      date_seen: props['Date seen'] || '2017-01-01',
      published: props['Published'] == 'Yes' || verifier.present?
    )
  end
end

World(Statements)
