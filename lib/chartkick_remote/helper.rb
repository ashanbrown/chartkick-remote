require 'active_support/core_ext'
require 'chartkick'

module Chartkick::Remote
  module Helper
    include Chartkick::Helper

    %w{line_chart pie_chart column_chart bar_chart area_chart geo_chart}.each do |type|
      define_method :"#{type}_with_remote" do |data_source = nil, options = {}, &block|
        chartkick_remote_chart type, data_source, options, &block
      end

      alias_method_chain :"#{type}", :remote
    end

    private

    def chartkick_remote_chart(type, data_source, options, &block)
      if block_given? && data_source.is_a?(Hash)
        options = data_source
      end

      is_remote = Chartkick.options.merge(options)[:remote]

      if is_remote
        @remote_chart_id = (@remote_chart_id || 0) + 1
        if controller.params[:_chartkick_remote_chart_id] # json request
          controller.chartkick_remote_blocks ||= {}
          controller.chartkick_remote_blocks[@remote_chart_id] = block
        else
          data_source = url_for(params.merge(_chartkick_remote_chart_id: @remote_chart_id, format: :json))
        end
      elsif block_given?
        data_source = block.call
      end

      send(:"#{type}_without_remote", data_source, options)
    end
  end
end
