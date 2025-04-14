module PermissionSystem
  class Role < ApplicationRecord
    self.table_name = 'permission_system_roles'

    belongs_to :profile

    validates :controller, presence: true
    validates :permission, presence: true
    validates :profile, presence: true
    validates :controller, uniqueness: { scope: [:profile_id, :permission] }

    scope :custom, -> { where(custom: true) }
    scope :default, -> { where(custom: false) }
  end
end 