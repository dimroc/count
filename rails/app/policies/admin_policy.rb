class AdminPolicy < ApplicationPolicy
  def granted?
    admin?
  end

  private

  def admin?
    user.present? && user.admin?
  end
end
