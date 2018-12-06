xml.instruct! :xml, version: '1.0'
xml.rss version: '2.0' do
  xml.channel do
    xml.title 'Modern Slavery Registry: Published Statements'
    xml.link 'https://www.modernslaveryregistry.org/'
    xml.description 'This RSS feed contains the most recently added statements from the Modern Slavery Registry'
    @statements.each do |statement|
      xml.item do
        xml.title "#{statement.company.name}: #{statement.period_covered}"
        xml.link company_statement_url(statement.company, statement)
        xml.pubDate statement.created_at.rfc2822
        xml.description(
          [
            "Legislation: #{statement.legislations.map(&:name).join(', ')}. ",
            "Authenticated by: #{statement.verified_by.name}. ",
            "Added on: #{l statement.date_seen, format: :long}."
          ].join
        )
      end
    end
  end
end
