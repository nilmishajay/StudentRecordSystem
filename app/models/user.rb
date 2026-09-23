class User < ApplicationRecord
  has_secure_password

  ROLES = %w[admin general].freeze

  after_initialize :set_default_role, if: :new_record?

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :role, presence: true, inclusion: { in: ROLES }

  private

  def set_default_role
    self.role ||= "general"
  end
end
