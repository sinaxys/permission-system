module PermissionSystem
  class Profile < ApplicationRecord
    self.table_name = 'permission_system_profiles'

    has_many :roles, dependent: :destroy
    has_many :user_profiles, dependent: :destroy
    has_many :users, through: :user_profiles

    validates :name, presence: true, uniqueness: true

    scope :active, -> { where(active: true) }
    scope :admin, -> { where(admin: true) }
    scope :regular, -> { where(admin: false) }
  end
end 