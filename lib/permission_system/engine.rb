module PermissionSystem
  class Engine < ::Rails::Engine
    isolate_namespace PermissionSystem

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_bot
      g.factory_bot dir: 'spec/factories'
    end

    initializer 'permission_system.initialize' do |app|
      ActiveSupport.on_load(:active_record) do
        extend PermissionSystem::HasPermissions
      end
    end
  end
end 