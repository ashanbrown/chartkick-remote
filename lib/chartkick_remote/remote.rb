module Chartkick::Remote
  extend ActiveSupport::Concern
  attr_accessor :chartkick_remote_blocks
  attr_accessor :chartkick_options

  included do
    class_attribute :chartkick_options
  end

  module Responder
    def to_json
      controller.render_to_string(options.merge(formats: [:html], layout: false))
      data_source = controller.chartkick_remote_blocks[controller.params[:_chartkick_remote_chart_id].to_i].call
      data_source = data_source.chart_json if data_source.respond_to?(:chart_json)
      render json: data_source
    end
  end

  def default_render(*)
    if params[:_chartkick_remote_chart_id]
      respond_with nil
    else
      super
    end
  end

  module ClassMethods
    def chartkick_remote(options = {})
      options = options.dup

      action_filter_options = options.extract!(:only, :except)

      respond_to :json, action_filter_options

      self.responder = Class.new(responder) do
        include Responder
      end

      before_filter action_filter_options do
        self.chartkick_options = self.class.chartkick_options
      end

      self.chartkick_options = {remote: true}.merge(options)
    end
  end
end
