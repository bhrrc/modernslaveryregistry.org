# frozen_string_literal: true

require 'csv'

def csv_file(obj)
  "#{File.dirname(__FILE__)}/seed_data/#{obj.name.tableize}.csv"
end

def import_table(obj)
  ActiveRecord::Base.transaction do
    CSV.foreach(csv_file(obj), headers: true) do |row|
      obj.find_or_create_by!(row.to_hash)
    end
  end
end

# Seed "static" tables
import_table(CallToAction)
import_table(Country)
import_table(Industry)
import_table(Legislation)
import_table(Page)

# Seed an admin user
admin_user = User.find_by_email('admin@example.com')
unless admin_user
  admin_user = User.new(
    email: 'admin@example.com',
    password: 'password',
    confirmed_at: Time.now,
    first_name: 'System',
    last_name: 'Administrator'
  )
end
admin_user.admin = true
admin_user.save
