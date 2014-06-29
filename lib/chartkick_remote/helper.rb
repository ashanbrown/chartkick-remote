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

      options = options.dup
      options.reverse_merge!(controller.chartkick_options) if controller.respond_to?(:chartkick_options)

      standalone = options.delete(:standalone)
      remote = options.delete(:remote)
      skip = false

      if remote
        @remote_chart_id = (@remote_chart_id || 0) + 1
        chart_id = controller.params[:_chartkick_remote_chart_id]
        if chart_id # json request
          controller.chartkick_remote_blocks ||= {}
          controller.chartkick_remote_blocks[@remote_chart_id] = block
          skip = standalone && chart_id.to_s == @remote_chart_id.to_s
        else
          data_source = url_for(params.merge(_chartkick_remote_chart_id: @remote_chart_id, format: :json))
        end
      elsif block_given?
        data_source = block.call
      end

      result = send(:"#{type}_without_remote", data_source, options)

      if remote && standalone
        result = '<div>Skipped</div>'.html_safe if skip

        standalone_link = link_to 'Standalone',
                                  url_for(params.merge(_chartkick_remote_chart_id: @remote_chart_id,
                                                       _chartkick_remote_standalone: 1))

        result += standalone_link.html_safe
      end

      result
    end
  end
end
