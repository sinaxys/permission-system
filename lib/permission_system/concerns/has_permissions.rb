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
      
      profiles.joins(:roles)
             .where(permission_system_roles: {
               controller: controller,
               permission: action
             }).exists?
    end

    def admin?
      profiles.where(admin: true).exists?
    end
  end
end 