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
      params[:permissions].each do |controller, actions|
        actions.each do |action, value|
          next unless value == "1"
          @profile.roles.create!(controller: controller, permission: action)
        end
      end
    end

    def load_controllers
      Rails.application.routes.routes.map do |route|
        route.defaults[:controller]
      end.compact.uniq.reject { |c| c.start_with?('rails/') }.sort
    end

    def load_permissions
      [:index, :show, :new, :create, :edit, :update, :destroy]
    end
  end
end 