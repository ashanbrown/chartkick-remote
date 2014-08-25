module Chartkick::Remote
  class Engine < ::Rails::Engine

    initializer "precompile", :group => :all do |app|
      app.config.assets.precompile << 'jquery.ajax.queue-concurrent.js'
    end

  end
end
