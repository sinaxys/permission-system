require "permission_system/version"
require "permission_system/engine"
require "permission_system/concerns/has_permissions"
require "permission_system/models/profile"
require "permission_system/models/role"
require "permission_system/models/user_profile"

module PermissionSystem
  class Error < StandardError; end
  class NotAuthorizedError < Error; end

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration) if block_given?
  end

  class Configuration
    attr_accessor :user_classes, :custom_authentication

    def initialize
      @user_classes = []
      @custom_authentication = nil
    end
  end
end 