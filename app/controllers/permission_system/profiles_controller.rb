module PermissionSystem
  class ProfilesController < ApplicationController
    before_action :set_profile, only: [:edit, :update, :destroy]

    def index
      @profiles = Profile.all
    end

    def new
      @profile = Profile.new
      @controllers = load_controllers
      @permissions = load_permissions
    end

    def create
      @profile = Profile.new(profile_params)
      
      if @profile.save
        create_roles if params[:permissions].present?
        redirect_to profiles_path, notice: 'Perfil criado com sucesso.'
      else
        @controllers = load_controllers
        @permissions = load_permissions
        render :new
      end
    end

    def edit
      @controllers = load_controllers
      @permissions = load_permissions
      @current_permissions = @profile.roles.pluck(:controller, :permission)
    end

    def update
      if @profile.update(profile_params)
        @profile.roles.destroy_all
        create_roles if params[:permissions].present?
        redirect_to profiles_path, notice: 'Perfil atualizado com sucesso.'
      else
        @controllers = load_controllers
        @permissions = load_permissions
        render :edit
      end
    end

    def destroy
      @profile.destroy
      redirect_to profiles_path, notice: 'Perfil removido com sucesso.'
    end

    private

    def set_profile
      @profile = Profile.find(params[:id])
    end

    def profile_params
      params.require(:profile).permit(:name, :admin, :active)
    end

    def create_roles
      ActiveRecord::Base.transaction do
        params[:permissions].each do |controller, actions|
          permitted_actions = actions.select { |_action, value| value == "1" }.keys
          next if permitted_actions.empty?
    
          @profile.roles.create!(controller: controller, permission: permitted_actions)
        end
      end
    rescue ActiveRecord::RecordInvalid => e
      flash[:error] = "Erro ao criar roles: #{e.message}"
      raise ActiveRecord::Rollback
    end

    def load_controllers
      yaml_path = Rails.root.join('config', 'permission_controllers.yml')
      if File.exist?(yaml_path) && (config = YAML.load_file(yaml_path)) && config['controllers']
        config['controllers'].map do |controller_name, controller_config|
          if controller_config.is_a?(Hash) && controller_config['name']
            { controller: controller_name, display_name: controller_config['name'] }
          else
            { controller: controller_name, display_name: controller_name.humanize }
          end
        end
      else
        Rails.application.routes.routes.map do |route|
          controller = route.defaults[:controller]
          { controller: controller, display_name: controller.humanize } if controller
        end.compact.uniq.reject { |c| c[:controller].start_with?('rails/') }.sort_by { |c| c[:controller] }
      end
    end
    

    def load_permissions
      yaml_path = Rails.root.join('config', 'permission_controllers.yml')
      if File.exist?(yaml_path) && (config = YAML.load_file(yaml_path)) && config['controllers']
        if params[:controller_filter].present? && config['controllers'][params[:controller_filter]]
          return config['controllers'][params[:controller_filter]]['permissions'].map(&:to_sym)
        end
        
        all_permissions = []
        config['controllers'].each do |_, controller_config|
          if controller_config.is_a?(Hash) && controller_config['permissions']
            all_permissions += controller_config['permissions']
          end
        end
        
        return all_permissions.uniq.map(&:to_sym).sort unless all_permissions.empty?
      end
      
      [:index, :show, :new, :create, :edit, :update, :destroy]
    end
  end
end 