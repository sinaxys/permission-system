module PermissionSystem
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('templates', __dir__)

    def copy_initializer
      template 'initializer.rb', 'config/initializers/permission_system.rb'
    end

    def copy_migrations
      rake 'permission_system:install:migrations'
    end

    def mount_engine
      route "mount PermissionSystem::Engine => '/permission_system'"
    end
  end
end 