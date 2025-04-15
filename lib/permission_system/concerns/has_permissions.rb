module PermissionSystem
  module HasPermissions
    extend ActiveSupport::Concern

    included do
      has_many :user_profiles,
               class_name: 'PermissionSystem::UserProfile',
               as: :user,
               dependent: :destroy
      has_many :profiles,
               through: :user_profiles,
               class_name: 'PermissionSystem::Profile'
    end

    def has_permission?(controller, action)
      return true if admin?
    
      profiles_with_roles = profiles.joins(:roles)
                                    .where(permission_system_roles: { controller: controller })
    
      profiles_with_roles.any? do |profile|
        profile.roles.any? { |role| role.permission.include?(action) }
      end
    end

    def admin?
      profiles.where(admin: true).exists?
    end
  end
end