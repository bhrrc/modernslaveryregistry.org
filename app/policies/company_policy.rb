class CompanyPolicy < ApplicationPolicy
  def update?
    user.admin?
  end
end
