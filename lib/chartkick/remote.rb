require 'chartkick/remote/helper'
require 'chartkick/remote/remote'

ActiveSupport.on_load(:action_view) do
  include Chartkick::Remote::Helper
end
