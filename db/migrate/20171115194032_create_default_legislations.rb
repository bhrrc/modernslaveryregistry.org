class CreateDefaultLegislations < ActiveRecord::Migration[5.0]
  def up
    msa = Legislation.find_or_create_by!(name: 'UK Modern Slavery Act', icon: 'gb')
    Legislation.find_or_create_by!(name: 'California Transparency in Supply Chains Act', icon: 'us')
    if LegislationStatement.count.zero?
      Statement.all.each do |statement|
        LegislationStatement.create!(statement: statement, legislation: msa)
      end
    end
  end
end
