 # rails generate permission_system:install
 # rails db:migrate
 # Adicionar os modelos que serão passiveis de permissões no path do projeto =>  'config/initializers/permission_system.rb'
 # use o permission_system/config/permission_controllers.yml como exemplo para montar quais recursos estarão disponíveis para as permissões no perfil
 # Adicione o Include nos modelos =>  include PermissionSystem::HasPermissions e ajuste de acordo com a demanda
   - Assim o modelo terá o método has_permission disponível para ser usado na view ou como um callback no controller.