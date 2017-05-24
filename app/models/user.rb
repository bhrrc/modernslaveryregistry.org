class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  validates :first_name, presence: true

  def after_confirmation
    if admin.nil?
      admin = email =~ /business-humanrights\.org$/
      update_attribute(:admin, admin)
    end
  end

  def name
    [first_name, last_name].compact.join(' ')
  end
end
