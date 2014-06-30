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

      if remote = options.delete(:remote)
        @remote_chart_id = (@remote_chart_id || 0) + 1
        controller.chartkick_remote_blocks ||= {}
        controller.chartkick_remote_blocks[@remote_chart_id] = block
        data_source = url_for(params.
                                except(:_chartkick_remote_standalone).
                                merge(_chartkick_remote_chart_id: @remote_chart_id, format: :json))
      elsif block_given?
        data_source = block.call
      end

      standalone = options.delete(:standalone)

      result = send(:"#{type}_without_remote", data_source, options)

      result = apply_standalone_mode(result, @remote_chart_id) if standalone && remote

      result
    end

    def apply_standalone_mode(result, chart_id)
      standalone_enabled = params[:_chartkick_remote_standalone].present?
      skip = standalone_enabled && params[:_chartkick_remote_chart_id].to_s != chart_id.to_s

      if skip || !standalone_enabled
        result = '<div>Skipped by Standalone Mode</div>'.html_safe if standalone_enabled
        standalone_link = link_to 'Standalone',
                                  url_for(params.merge(_chartkick_remote_chart_id: chart_id,
                                                       _chartkick_remote_standalone: 1))
        result += standalone_link.html_safe
      elsif standalone_enabled && !skip
        standalone_link = link_to 'Exit Standalone Mode',
                                  url_for(params.except(:_chartkick_remote_chart_id,
                                                        :_chartkick_remote_standalone))
        result += standalone_link.html_safe
      end

      result
    end
  end
end
