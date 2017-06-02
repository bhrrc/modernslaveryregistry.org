module Statements
  def submit_statement(props)
    props = props.with_indifferent_access
    verifier = find_or_create_verifier(props)
    company = find_or_create_company(props)
    create_statement(company, verifier, props)
  end

  private

  def find_or_create_company(props)
    sector = Sector.find_by!(name: props['sector'] || 'Software')
    country = Country.find_by!(name: props['country'] || 'United Kingdom')
    company = Company.find_or_create_by!(name: props['company_name'], sector: sector, country: country)
    company
  end

  def find_or_create_verifier(props)
    props['verified_by'].present? && User.where(
      first_name: props['verified_by'],
      email: "#{props['verified_by']}@host.com"
    ).first_or_create(password: 'whatevs')
  end

  def create_statement(company, verifier, props)
    company.statements.create!(
      url: props.fetch('statement_url'),
      signed_by_director: 'No',
      approved_by_board: 'Not explicit',
      link_on_front_page: 'No',
      contributor_email: props['contributor_email'],
      verified_by: verifier,
      date_seen: props['date_seen'] || '2017-01-01',
      published: verifier.present?
    )
  end
end

World(Statements)
