xml.instruct! :xml, :version => '1.0'
xml.rss :version => '2.0' do
  xml.channel do
    xml.title 'title'
    xml.link 'link'
    xml.description 'description'
    @statements.each do |statement|
      xml.item do
        xml.title statement.company.name
        xml.link admin_company_statement_url(statement.company, statement)
      end
    end
  end
end
