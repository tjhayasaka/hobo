require 'hobo'
require 'rails'
require 'rails/generators'


module Hobo
  class Engine < Rails::Engine

    ActiveSupport.on_load(:before_configuration) do
      h = config.hobo = ActiveSupport::OrderedOptions.new
      h.app_name = self.class.name.split('::').first.underscore.titleize
      h.developer_features = Rails.env.in?(["development", "test"])
      h.routes_path = Pathname.new File.expand_path('config/hobo_routes.rb', Rails.root)
      h.rapid_generators_path = Pathname.new File.expand_path('lib/hobo/rapid/generators', Hobo.root)
      h.auto_taglibs_path = Pathname.new File.expand_path('app/views/taglibs/auto', Rails.root)
    end

    ActiveSupport.on_load(:action_controller) do
      require 'hobo/extensions/action_controller/hobo_methods'
      require 'hobo/extensions/action_mailer/helper'
    end

    ActiveSupport.on_load(:active_record) do
      require 'hobo/extensions/active_record/association_collection'
      require 'hobo/extensions/active_record/association_proxy'
      require 'hobo/extensions/active_record/association_reflection'
      require 'hobo/extensions/active_record/hobo_methods'
      require 'hobo/extensions/active_record/permissions'
      require 'hobo/extensions/active_record/scopes'
      require 'hobo/extensions/active_model/name'
      require 'hobo/extensions/active_model/translation'
    end

    ActiveSupport.on_load(:action_view) do
      require 'hobo/extensions/action_view/tag_helper'
    end

    ActiveSupport.on_load(:before_initialize) do
      require 'hobo/undefined'

      h = config.hobo
      Dryml::DrymlGenerator.enable([h.rapid_generators_path], h.auto_taglibs_path)

      HoboFields.never_wrap(Hobo::Undefined)
    end

    initializer 'hobo.routes' do |app|
      h = app.config.hobo
      # generate at first boot, so no manual generation is required
      Rails::Generators.invoke('hobo:routes', %w[-f -q]) unless File.exists?(h.routes_path)
      app.routes_reloader.paths << h.routes_path
      app.config.to_prepare do
        Rails::Generators.configure!
        # generate before each request in development
        Rails::Generators.invoke('hobo:routes', %w[-f -q])
      end
    end

    initializer 'hobo.dryml' do |app|
      app.config.to_prepare do
        Dryml::DrymlGenerator.run
      end
    end

  end
end
