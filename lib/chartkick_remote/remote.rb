module Chartkick::Remote
  extend ActiveSupport::Concern
  attr_accessor :chartkick_remote_blocks

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
      self.chartkick_options = {remote: true}.merge(options.except(:only, :except))
      respond_to :json, options
      self.responder = Class.new(responder) do
        include Responder
      end
    end
  end
end
