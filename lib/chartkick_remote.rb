require 'chartkick_remote/helper'
require 'chartkick_remote/remote'

ActiveSupport.on_load(:action_view) do
  include Chartkick::Remote::Helper
end
