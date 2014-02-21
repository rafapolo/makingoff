require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(:default, Rails.env)

module Makingoff
  class Application < Rails::Application
    config.generators do |g| 
        g.template_engine :haml 
    end 
  end
end
