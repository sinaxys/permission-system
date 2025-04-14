class CreatePermissionSystemTables < ActiveRecord::Migration[7.0]
  def change
    create_table :permission_system_profiles do |t|
      t.string :name, null: false
      t.boolean :admin, default: false
      t.boolean :active, default: true
      t.timestamps
    end

    add_index :permission_system_profiles, :name, unique: true

    create_table :permission_system_roles do |t|
      t.references :profile, null: false, foreign_key: { to_table: :permission_system_profiles }
      t.string :controller, null: false
      t.string :permission, null: false
      t.boolean :custom, default: false
      t.timestamps
    end

    add_index :permission_system_roles, [:profile_id, :controller, :permission], unique: true, name: 'idx_permission_system_roles_unique'

    create_table :permission_system_user_profiles do |t|
      t.references :user, polymorphic: true, null: false
      t.references :profile, null: false, foreign_key: { to_table: :permission_system_profiles }
      t.timestamps
    end

    add_index :permission_system_user_profiles, [:user_type, :user_id, :profile_id], unique: true, name: 'idx_permission_system_user_profiles_unique'
  end
end 