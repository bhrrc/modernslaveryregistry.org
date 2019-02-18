class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  validates :first_name, presence: true

  def after_confirmation
    return unless admin.nil?

    admin = email =~ /business-humanrights\.org$/
    update_attribute(:admin, admin) # rubocop:disable Rails/SkipsModelValidations
  end

  def name
    [first_name, last_name].compact.join(' ')
  end

  def self.search(query)
    wild = "%#{query}%"
    User.where(
      'lower(first_name) like lower(?) or lower(last_name) like lower(?) or lower(email) like lower(?)',
      wild,
      wild,
      wild
    )
  end
end
