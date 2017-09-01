# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'csv'

# Import countries
ActiveRecord::Base.transaction do
  CSV.foreach(File.dirname(__FILE__) + '/countries.csv', headers: true) do |row|
    Country.find_or_create_by!(row.to_hash)
  end
end

admin = ENV['SEED_ADMIN_EMAIL'] ? User.find_by_email!(ENV['SEED_ADMIN_EMAIL']) :
  User.where(email: 'admin@test.com').first_or_create!(
    password: 'password',
    confirmed_at: Time.zone.now,
    admin: true,
    first_name: 'Adam'
  )

filename = ARGV[0]
puts 'Importing statements...'
stms = []

CSV.foreach(File.dirname(__FILE__) + '/statements.csv', headers: true) do |row|
  country_name = row['country_name'].strip
  country = Country.find_by_name!(country_name)

  sector_params = { name: row['new_sector_name'].strip }
  sector = sector_params[:name] ? Sector.find_or_create_by!(sector_params) : nil

  company_params = {
    name: row['company_name'].strip,
    country: country,
    sector: sector
  }
  company = Company.find_or_create_by!(company_params)

  statement_params = {
    url: row['statement_url'].strip.delete("^\u{0000}-\u{007F}"),
    date_seen: row['date_seen'],
    approved_by_board: row['approved_by_board'],
    approved_by: row['approved_by'],
    signed_by_director: !!(row['signed_by_director'] =~ /yes/i),
    signed_by: row['signed_by'],
    link_on_front_page: !!(row['link_on_front_page'] =~ /yes/i),
    company: company,
    verified_by: admin,
    contributor_email: admin.email,
    published: true
  }
  begin
    statement = Statement.find_or_create_by!(statement_params)
    if statement.broken_url
      STDERR.write 'X'
    else
      STDERR.write URI(statement.url).scheme == 'https' ? '.' : '!'
    end
  rescue => e
    puts statement_params.inspect
    raise e
  end
end


Page.where(
  slug: 'about_us',
  title: 'About us',
  short_title: 'About us',
  body_html: <<~HTML
<p>
  Section 54 of the
  <a href="http://www.legislation.gov.uk/ukpga/2015/30/contents/enacted">UK Modern Slavery Act</a>
  requires commercial organisations
  that operate in the UK and have an annual turnover above £36m to produce a
  statement setting out the steps they are taking to address and prevent the
  risk of modern slavery in their operations and supply chains; it is also
  known as the Transparency in Supply Chains clause (TISC). A number of key
  stakeholders that were influential in securing the inclusion of the TISC
  clause also advocated for the Government to create a central registry that
  would host modern slavery statements. The Government has maintained its
  position that it will not establish a central registry, however, it does
  agree that such a resource would be valuable.
</p>
<p>
  The Modern Slavery Registry, operated and maintained by the Business &amp;
  Human Rights Resource Centre, seeks to fulfil the role left by Government.
  The Business &amp; Human Rights Resource Centre and its partners agree that
  a central registry should meet a core set of criteria. It should be:
  independent, accountable to the public interest, robust, credible, free,
  open, accessible and sustainable in the long term. A resource that meets
  these criteria will enable stakeholders to analyse whether statements are
  in compliance with the legislation and analyse the quality of reporting.
</p>
<p>
  This Registry is guided and supported by a governance committee which
  includes: Freedom Fund, Humanity United, Freedom United, Anti-Slavery
  International, the Ethical Trading Initiative, CORE Coalition, UNICEF UK,
  Focus on Labour Exploitation, and Oxfam GB.
</p>
HTML
).first_or_create

Page.where(
  slug: 'reporting_guidance',
  title: 'Reporting Guidance and Resources',
  short_title: 'Reporting guidance',
  body_html: <<~HTML
<p>
  Section 54 of the
  <a href="http://www.legislation.gov.uk/ukpga/2015/30/contents/enacted">UK Modern Slavery Act</a>
  requires companies to produce a
  statement that describes what actions they are taking to address modern
  slavery in their operations and supply chains. This is not intended to be,
  and should be approached, as a compliance exercise. Rather, companies are
  encouraged to take the necessary time and effort to consider their existing
  processes and practices related to modern slavery, as well as labour
  standards more generally. An effective, informative and substantive
  statement will address and report on modern slavery in the context of a
  broader human rights due diligence context. The guidance provided here will
  assist companies understand stakeholders expectations of modern slavery
  statements under Section 54.
</p>
<ul>
  <li>
    <a href="http://corporate-responsibility.org/wp-content/uploads/2016/03/CSO_TISC_guidance_final_digitalversion_16.03.16.pdf">Beyond Compliance&nbsp;: Effective Reporting Under the Modern Slavery Act</a>, CORE Coalition
  </li>
  <li>
    <a href="https://www.gov.uk/government/uploads/system/uploads/attachment_data/file/471996/Transparency_in_Supply_Chains_etc__A_practical_guide__final_.pdf">Transparency in Supply Chains, etc., A Practical Guide</a>, Home Office
  </li>
  <li>
    <a href="https://business-humanrights.org/sites/default/files/documents/FTSE%20100%20Modern%20Slavery%20Act.pdf">FTSE 100 At the Starting Line: An Analysis of Company Statements Under the UK Modern Slavery Act</a>, Business &amp; Human Rights Resource Centre
  </li>
  <li>
    <a href="http://www.ethicaltrade.org/blog/new-report-and-survey-finds-modern-slavery-act-galvanising-leadership-action-in-progressive">Corporate Leadership on Modern Slavery</a>, Ethical Trading Initiative and Hult International Business School
  </li>
  <li>
    <a href="http://www.ergonassociates.net/images/stories/articles/msa_one_year_on_april_2017.pdf">Modern slavery statements: One year on</a>, Ergon Associates
  </li>
</ul>
HTML
).first_or_create

Page.where(
  slug: 'contact_us',
  title: 'Contact us',
  short_title: 'Contact us',
  body_html: <<~HTML
<p>
  To submit a statement please see <a href="/companies/new">here</a>.
</p>
<p>
  For <strong>general enquiries</strong> please contact:
</p>
<p>
  Patricia Carrier - <a href="mailto:carrier@business-humanrights.org">carrier@business-humanrights.org</a>,
  +44 (0)20 7636 7774
</p>
<p>
  For <strong>media enquiries</strong> please contact:
</p>
<p>
  Joe Bardwell - <a href="mailto:bardwell@business-humanrights.org">bardwell@business-humanrights.org</a>,
  +44 (0)79666 36981
</p>
HTML
).first_or_create
