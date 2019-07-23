module Statements
  def submit_statement(props)
    props['Company name']    = SecureRandom.uuid unless props.include?('Company name')
    props['Statement URL']   = 'https://' + SecureRandom.uuid unless props.include?('Statement URL')
    related_companies    = props.delete('Related companies')
    verifier                 = find_or_create_verifier(props)
    company                  = find_or_create_company(props, related_companies)
    create_statement(company, verifier, props, related_companies)
  end

  private

  def find_or_create_company(props, related_companies)
    industry = Industry.find_by!(name: props.delete('Industry') || 'Software')
    country = Country.find_by!(name: props.delete('Country') || 'United Kingdom')
    company = Company.find_or_create_by!(
      name: props.delete('Company name'), 
      related_companies: related_companies,
      industry: industry, country: country,
      company_number: props.delete('Company number')
    )
    company
  end

  def find_or_create_verifier(props)
    name = props.delete('Verified by')
    return nil if name.nil?

    User.where(first_name: name, email: "#{name}@host.com").first_or_create(password: 'whatevs')
  end

  def create_statement(company, verifier, props, related_companies)
    statement = company.statements.create!(
      default_statement_attributes.merge(
        url: props.delete('Statement URL'),
        verified_by: verifier,
        approved_by_board: props.delete('Approved by board') || 'Not explicit',
        legislations: (props.delete('Legislations') || '').split(',').map do |name|
          Legislation.find_by!(name: name.strip)
        end
      ).merge(overridden_attributes(props))
    )
    
    related_company_names = related_companies.nil? ? [] : related_companies.split(/,\s*/)
    related_company_names.each do |related_company_name|
      statement.additional_companies_covered << Company.find_or_create_by!(name: related_company_name)
    end
  end

  def overridden_attributes(props)
    overrides = {}
    props.each do |key, value|
      overrides[key.downcase.tr(' ', '_').to_sym] = attribute_value(value)
    end
    overrides
  end

  def attribute_value(string)
    return true if string == 'Yes'
    return false if string == 'No'

    string
  end

  def default_statement_attributes
    {
      signed_by_director: false,
      link_on_front_page: false,
      date_seen: '2017-01-01'
    }
  end
end

World(Statements)
