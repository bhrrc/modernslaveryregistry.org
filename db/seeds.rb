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
  CSV.foreach(File.dirname(__FILE__) + '/countries.csv', :headers => true) do |row|
    Country.create!(row.to_hash)
  end
end

# Import statements. This is a bit hacky, it's working around various
# idiosyncracies in the spreadsheet maintained by BHRRC.

class NilClass
  def strip
    nil
  end
end

def date_seen(ds)
  return nil if ds.nil? # TODO: use prev date
  ds = '12/20/16' if ds == '12/202/16'
  if ds.strip
    begin
      Date.strptime(ds, "%d/%m/%y")
    rescue
      Date.strptime(ds, "%m/%d/%y")
    end
  else
    nil
  end
end

def yes_no_bool(s)
  return false if s.nil?
  !!(s =~ /yes/i)
end

def signed_by(s)
  return nil if s.nil?
  s.strip
end

def approved_by_board(s)
  return 'Not explicit' if s.nil?
  s = s.strip
  s = 'Yes' if s == 'yes'
  s
end

def approved_by(s)
  return nil if s.nil?
  s = s.strip
  s = 'Group CEO on behalf of Board' if s == 'Group CEO o nbehalf of Board'
  s = 'Board of Trustees' if s == 'Boad of Trustees'
  s
end

filename = ARGV[0]
puts "Importing statements..."
stms = []
ActiveRecord::Base.transaction do
  CSV.foreach(File.dirname(__FILE__) + '/statements.csv', :headers => true) do |row|
    country_name = row['COUNTRY OF HQ OF CO. PROVIDING STATEMENT'].strip
    country_name = "United Kingdom" if country_name == "UK"
    country_name = "United Kingdom" if country_name == "Uk"
    country_name = "United States" if country_name == "USA"
    country_name = "United Arab Emirates" if country_name == "UAE"
    country_name = "United Arab Emirates" if country_name == "Dubai"
    country_name = "South Africa" if country_name == "S. Africa"
    country = Country.find_by_name!(country_name)

    sector_params = {name: row['SECTOR'].strip}
    sector = sector_params[:name] ? Sector.find_or_create_by!(sector_params) : nil

    company_params = {
      name: row['COMPANY'],
      country_id: country.id,
      sector: sector
    }
    company = Company.find_or_create_by!(company_params)

    statement_params = {
      url: row[' STATEMENT'].strip,
      date_seen: date_seen(row['DATE SEEN']),
      approved_by_board: approved_by_board(row['STATEMENT APPROVED BY BOARD/MEMBER/PARTNER 54(6)(a-d)']),
      approved_by: approved_by(row['WHO APPROVED']),
      signed_by_director: yes_no_bool(row['STATEMENT SIGNED BY DIRECTOR/MEMBER/PARTNER 54(6)(a-d)']),
      signed_by: signed_by(row['Title of person who signed']),
      link_on_front_page: yes_no_bool(row['LINK TO STATEMENT ON HOMEPAGE OF WEBSITE 54(7)(b)']),

      company_id: company.id
    }
    statement = Statement.find_or_create_by!(statement_params)
    if statement.broken_url
      STDOUT.write 'X'
    else
      STDOUT.write URI(statement.url).scheme == 'https' ? '.' : '!'
    end
  end
end
