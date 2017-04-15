class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  def after_confirmation
    if self.admin.nil?
      admin = self.email =~ /business-humanrights\.org$/
      self.update_attribute(:admin, admin)
    end
  end
end