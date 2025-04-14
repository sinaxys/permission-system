module PermissionSystem
  class UserProfile < ApplicationRecord
    self.table_name = 'permission_system_user_profiles'

    belongs_to :user, polymorphic: true
    belongs_to :profile

    validates :user, presence: true
    validates :profile, presence: true
    validates :profile_id, uniqueness: { scope: [:user_type, :user_id] }
  end
end 