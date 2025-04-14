Gem::Specification.new do |spec|
  spec.name = "permission_system"
  spec.version = "0.1.0"
  spec.authors = ["Andre Moreira"]
  spec.email = ["andre.torres@sinaxys.com"]

  spec.summary = "Flexible permission system for Rails applications"
  spec.description = "A comprehensive and flexible permission system that can be integrated with any Rails application"
  spec.homepage = "https://github.com/andre-dan/permission_system"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/andre-dan/permission_system"
  spec.metadata["changelog_uri"] = "https://github.com/andre-dan/permission_system/blob/main/CHANGELOG.md"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", ">= 6.1"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "factory_bot_rails"
  spec.add_development_dependency "database_cleaner-active_record"
end 