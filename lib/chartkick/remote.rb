require 'chartkick/remote/helper'
require 'chartkick/remote/remote'
require 'chartkick/remote/engine' if defined?(Rails)

ActiveSupport.on_load(:action_view) do
  include Chartkick::Remote::Helper
end
