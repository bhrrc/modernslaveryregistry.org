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

admin = User.find_by_email!(ENV['SEED_ADMIN_EMAIL'])
filename = ARGV[0]
puts 'Importing statements...'
stms = []
ActiveRecord::Base.transaction do
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
end
